from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session
from . import models, schemas, database
import logging
import os

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('/app/logs/app.log'),
        logging.StreamHandler()
    ]
)

logger = logging.getLogger(__name__)
os.makedirs('/app/logs', exist_ok=True)
models.Base.metadata.create_all(bind=database.engine)

app = FastAPI(title="Blog Server", version="1.0.0")

@app.get("/posts", response_model=list[schemas.Post])
async def get_posts(db: Session = Depends(database.get_db)):
    """Get all posts"""
    logger.info("Fetching all posts")
    posts = db.query(models.Post).all()
    return posts

@app.post("/posts", response_model=schemas.Post)
async def create_post(post: schemas.PostCreate, db: Session = Depends(database.get_db)):
    """Create a new post"""
    logger.info(f"Creating new post with title: {post.title}")
    
    db_post = models.Post(title=post.title, content=post.content)
    db.add(db_post)
    db.commit()
    db.refresh(db_post)
    
    logger.info(f"Created post with ID: {db_post.id}")
    return db_post

@app.get("/")
async def root():
    """Root endpoint"""
    return {
        "message": "Blog Server API",
        "docs": "/docs"
    }
