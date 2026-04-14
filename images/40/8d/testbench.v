`timescale 1ns/1ps

module virtual_memory_management_tb;

    // Testbench signals (sequential circuit)
    reg add_page;
    reg clk;
    reg [3:0] page_id;
    reg remove_page;
    reg reset;
    wire page_found;
    wire [15:0] page_table;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    virtual_memory_management dut (
        .add_page(add_page),
        .clk(clk),
        .page_id(page_id),
        .remove_page(remove_page),
        .reset(reset),
        .page_found(page_found),
        .page_table(page_table)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            add_page = 0;
            remove_page = 0;
            page_id = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Add Page ID 3", test_num);
            reset_dut();

            page_id = 4'd3;
            add_page = 1;
            @(posedge clk);
            #1 add_page = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b1, 16'h0008);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Add multiple pages (0, 7, 15)", test_num);
            reset_dut();


            page_id = 4'd0; add_page = 1; @(posedge clk); #1;

            page_id = 4'd7; add_page = 1; @(posedge clk); #1;

            page_id = 4'd15; add_page = 1; @(posedge clk); #1;
            add_page = 0;
            @(posedge clk);



            #1;




            check_outputs(1'b1, 16'h8081);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Add and Remove Page ID 5", test_num);
            reset_dut();


            page_id = 4'd5; add_page = 1; @(posedge clk); #1;
            add_page = 0;
            @(posedge clk);


            page_id = 4'd5; remove_page = 1; @(posedge clk); #1;
            remove_page = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b0, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Check page_found for missing ID", test_num);
            reset_dut();


            page_id = 4'd10; add_page = 1; @(posedge clk); #1;
            add_page = 0;
            @(posedge clk);


            page_id = 4'd2;
            @(posedge clk);


            #1;



            check_outputs(1'b0, 16'h0400);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Remove non-existent page", test_num);
            reset_dut();


            page_id = 4'd1; add_page = 1; @(posedge clk); #1;
            add_page = 0;
            @(posedge clk);


            page_id = 4'd12; remove_page = 1; @(posedge clk); #1;
            remove_page = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b0, 16'h0002);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify reset wipes table mid-operation", test_num);
            reset_dut();


            page_id = 4'd4; add_page = 1; @(posedge clk); #1;
            add_page = 0;
            @(posedge clk);


            reset = 1;
            @(posedge clk);
            reset = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b0, 16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("virtual_memory_management Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input expected_page_found;
        input [15:0] expected_page_table;
        begin
            if (expected_page_found === (expected_page_found ^ page_found ^ expected_page_found) &&
                expected_page_table === (expected_page_table ^ page_table ^ expected_page_table)) begin
                $display("PASS");
                $display("  Outputs: page_found=%b, page_table=%h",
                         page_found, page_table);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: page_found=%b, page_table=%h",
                         expected_page_found, expected_page_table);
                $display("  Got:      page_found=%b, page_table=%h",
                         page_found, page_table);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,add_page, clk, page_id, remove_page, reset, page_found, page_table);
    end

endmodule
