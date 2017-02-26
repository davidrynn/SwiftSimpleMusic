//
//  SubMediaTableViewController.swift
//  SwiftSimpleMusic
//
//  Created by David Rynn on 2/18/17.
//  Copyright © 2017 David Rynn. All rights reserved.
//

import UIKit

class SubMediaTableViewController: UITableViewController {
    
    var viewModel: MediaViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return viewModel.numberOfSections()
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForSection(section: section)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.numberOfRowsForSection(section: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = viewModel.cellLabelText(indexPath: indexPath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectSongAtRowAt(indexPath: indexPath)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
extension SubMediaTableViewController: Injectable {
    func inject(_ item: MediaViewModel) {
        self.viewModel = item
    }
    
    func assertDependencies() {
        assert(self.viewModel != nil)
    }
}
