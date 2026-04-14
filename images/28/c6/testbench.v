`timescale 1ns/1ps

module quick_sort_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    quick_sort dut (
        .clk(clk),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        data_in = 16'h0000;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Already Sorted Input (1, 2, 3, 4)", test_num);
        reset_dut();
        data_in = 16'h4321;
        @(posedge clk);
        @(posedge clk);
        #2;
        #1;

        check_outputs(16'h4321);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reverse Sorted Input (4, 3, 2, 1)", test_num);
        reset_dut();
        data_in = 16'h1234;
        @(posedge clk);
        @(posedge clk);
        #2;
        #1;

        check_outputs(16'h4321);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All Identical Values (A, A, A, A)", test_num);
        reset_dut();
        data_in = 16'hAAAA;
        @(posedge clk);
        @(posedge clk);
        #2;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Random with Duplicates (2, 8, 2, 5)", test_num);
        reset_dut();
        data_in = 16'h2825;
        @(posedge clk);
        @(posedge clk);
        #2;
        #1;

        check_outputs(16'h8522);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Min and Max Edge Values (F, 0, F, 0)", test_num);
        reset_dut();
        data_in = 16'hF0F0;
        @(posedge clk);
        @(posedge clk);
        #2;
        #1;

        check_outputs(16'hFF00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Scattered Values (E, 7, 1, 9)", test_num);
        reset_dut();
        data_in = 16'hE719;
        @(posedge clk);
        @(posedge clk);
        #2;
        #1;

        check_outputs(16'hE971);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Single High Value (0, C, 0, 0)", test_num);
        reset_dut();
        data_in = 16'h0C00;
        @(posedge clk);
        @(posedge clk);
        #2;
        #1;

        check_outputs(16'hC000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("quick_sort Testbench");
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
        input [15:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, data_out);
    end

endmodule
