# Notes

- One of the more important decisions in my mind in terms of architecture was where to cut the line between the responsibilities of the ClearanceBatches Controller and the clearancing service. I decided to give the responsibility of checking input validity to the controller. Although it makes the controller more dense, it allows the service to keep really focused on it's single responsibilty. By pre-formatting the inputs and sending only an array of ids to the service the service is prevented from having to make guesses about which kinds of formats it will have to validate keeping it totally modular and reusable. Any thing which instantiates the service will have a better idea of what input formats to expect and can validate them as needed.

Besides that I just tried to keep the controller actions clean and move more specific logic in to single purpose private methods

- I considered breaking the input validators out into there own services but ended up deciding it was a wash in terms of value as they are pretty small now. If there was any more complex logic in them or in the event that there were other apps which could reuse those validations than I think it would make sense to break them out into seperate services.

- My focus on refactoring the clearancing service was to keep its public interface as clean as possible. An app which uses the service now needs to know very little about it besides one public method and what data it accepts. The service was also making multiple unneccessary queries so I started caching valid items in the clearincing_status meaning the database only has to be hit once for each item.

- I added a script which allows downloading all the tables in the app as excel files. I consider this an extra and it isn't production ready. It doesn't really work on my machine (it downloads just the text which you can open with excel) but I'm guessing it may work on a windows machine??


- Tried to keep the views as modular as possible