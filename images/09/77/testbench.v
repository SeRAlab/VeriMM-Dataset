`timescale 1ns/1ps

module MMU_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [9:0] page_table_base;
    reg reset;
    reg valid;
    reg [9:0] virtual_address;
    wire page_fault;
    wire [9:0] physical_address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    MMU dut (
        .clk(clk),
        .page_table_base(page_table_base),
        .reset(reset),
        .valid(valid),
        .virtual_address(virtual_address),
        .page_fault(page_fault),
        .physical_address(physical_address)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            valid = 0;
            page_table_base = 0;
            virtual_address = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Translation", test_num);
            reset_dut();

            page_table_base = 10'h040;
            virtual_address = 10'h005;
            valid = 1;

            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b0, 10'h045);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Page Fault Handling", test_num);
            reset_dut();

            page_table_base = 10'h010;
            virtual_address = 10'h3FF;
            valid = 1;

            @(posedge clk);
            #2;



            #1;




            check_outputs(1'b1, 10'h000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Base Address Shift", test_num);
            reset_dut();

            page_table_base = 10'h200;
            virtual_address = 10'h020;
            valid = 1;

            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b0, 10'h220);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Inactive Valid Signal", test_num);
            reset_dut();

            page_table_base = 10'h040;
            virtual_address = 10'h005;
            valid = 0;

            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b0, 10'h000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Address Translation", test_num);
            reset_dut();

            page_table_base = 10'h100;
            virtual_address = 10'h000;
            valid = 1;

            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b0, 10'h100);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary Address Translation", test_num);
            reset_dut();

            page_table_base = 10'h3F0;
            virtual_address = 10'h00F;
            valid = 1;

            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b0, 10'h3FF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("MMU Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input expected_page_fault;
        input [9:0] expected_physical_address;
        begin
            if (expected_page_fault === (expected_page_fault ^ page_fault ^ expected_page_fault) &&
                expected_physical_address === (expected_physical_address ^ physical_address ^ expected_physical_address)) begin
                $display("PASS");
                $display("  Outputs: page_fault=%b, physical_address=%h",
                         page_fault, physical_address);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: page_fault=%b, physical_address=%h",
                         expected_page_fault, expected_physical_address);
                $display("  Got:      page_fault=%b, physical_address=%h",
                         page_fault, physical_address);
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
        $dumpvars(0,clk, page_table_base, reset, valid, virtual_address, page_fault, physical_address);
    end

endmodule
