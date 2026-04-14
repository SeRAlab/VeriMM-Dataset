`timescale 1ns/1ps

module parallel_load_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [11:0] data_in;
    reg load;
    reg reset;
    wire [11:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    parallel_load_register dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .reset(reset),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(negedge clk);
        reset = 1;
        load = 0;
        data_in = 12'h000;
        @(negedge clk);
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Load value 0xABC", test_num);
        reset_dut();
        @(negedge clk);
        load = 1;
        data_in = 12'hABC;
        @(posedge clk);
        #1;
        #1;

        check_outputs(12'hABC);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Load disabled (Hold value)", test_num);
        reset_dut();

        @(negedge clk);
        load = 1;
        data_in = 12'h555;
        @(posedge clk);

        @(negedge clk);
        load = 0;
        data_in = 12'hAAA;
        @(posedge clk);
        #1;
        #1;

        check_outputs(12'h555);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset priority over Load", test_num);
        reset_dut();
        @(negedge clk);
        reset = 1;
        load = 1;
        data_in = 12'hFFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary values (0x000 then 0xFFF)", test_num);
        reset_dut();

        @(negedge clk);
        load = 1;
        data_in = 12'hFFF;
        @(posedge clk);
        #1;

        @(negedge clk);
        data_in = 12'h000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sequential Load sequence", test_num);
        reset_dut();
        @(negedge clk);
        load = 1;
        data_in = 12'h123;
        @(posedge clk);
        @(negedge clk);
        data_in = 12'h456;
        @(posedge clk);
        @(negedge clk);
        data_in = 12'h789;
        @(posedge clk);
        #1;
        #1;

        check_outputs(12'h789);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Synchronous reset check", test_num);
        reset_dut();

        @(negedge clk);
        load = 1;
        data_in = 12'hDEAD;
        @(posedge clk);

        @(negedge clk);
        reset = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(12'h000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("parallel_load_register Testbench");
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
        input [11:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, load, reset, data_out);
    end

endmodule
