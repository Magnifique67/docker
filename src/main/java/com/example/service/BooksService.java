package com.example.service;

import com.example.model.Book;
import com.example.repository.BooksRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class BooksService {
    private final BooksRepository booksRepository;

    @Autowired
    public BooksService(BooksRepository booksRepository) {
        this.booksRepository = booksRepository;
    }

    public List<Book> getAllBooks() {
        return booksRepository.findAll();
    }

    public Optional<Book> getBookById(int id) {
        return booksRepository.findById(id);
    }

    public Book createBook(Book book) {
        return booksRepository.save(book);
    }

    public Book updateBook(int id, Book book) {
        book.setId(id);
        return booksRepository.save(book);
    }

    public void deleteBook(int id) {
        booksRepository.deleteById(id);
    }
}
