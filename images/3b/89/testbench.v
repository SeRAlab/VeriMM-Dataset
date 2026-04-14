`timescale 1ns/1ps

module pcie_endpoint_controller_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] addr_in;
    reg clk;
    reg [31:0] data_in;
    reg rst;
    reg valid;
    wire [31:0] addr_out;
    wire [31:0] data_out;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_endpoint_controller dut (
        .addr_in(addr_in),
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .valid(valid),
        .addr_out(addr_out),
        .data_out(data_out),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            valid = 0;
            addr_in = 0;
            data_in = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Single Transaction", test_num);
            reset_dut();


            addr_in = 32'h1234_5678;
            data_in = 32'hDEAD_BEEF;
            valid = 1;

            @(posedge clk);
            #1;
            valid = 0;


            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h1234_5678, 32'hDEAD_BEEF, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset State Verification", test_num);
            reset_dut();


            #1;



            check_outputs(32'h0, 32'h0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Data ignore when valid is low", test_num);
            reset_dut();


            addr_in = 32'hAAAA_BBBB;
            data_in = 32'hCCCC_DDDD;
            valid = 0;

            @(posedge clk);
            #1;

            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h0, 32'h0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Successive Transactions", test_num);
            reset_dut();


            addr_in = 32'h1111_1111;
            data_in = 32'h2222_2222;
            valid = 1;
            @(posedge clk);
            #1;


            addr_in = 32'h8888_8888;
            data_in = 32'h9999_9999;
            valid = 1;
            @(posedge clk);
            #1;
            valid = 0;


            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h8888_8888, 32'h9999_9999, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum Values Transaction", test_num);
            reset_dut();

            addr_in = 32'hFFFF_FFFF;
            data_in = 32'hFFFF_FFFF;
            valid = 1;

            @(posedge clk);
            #1;
            valid = 0;

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hFFFF_FFFF, 32'hFFFF_FFFF, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_endpoint_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [31:0] expected_addr_out;
        input [31:0] expected_data_out;
        input expected_ready;
        begin
            if (expected_addr_out === (expected_addr_out ^ addr_out ^ expected_addr_out) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: addr_out=%h, data_out=%h, ready=%b",
                         addr_out, data_out, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addr_out=%h, data_out=%h, ready=%b",
                         expected_addr_out, expected_data_out, expected_ready);
                $display("  Got:      addr_out=%h, data_out=%h, ready=%b",
                         addr_out, data_out, ready);
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
        $dumpvars(0,addr_in, clk, data_in, rst, valid, addr_out, data_out, ready);
    end

endmodule
