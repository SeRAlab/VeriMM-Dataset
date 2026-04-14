`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] addr;
    reg clk;
    reg [31:0] data_in;
    reg rw;
    wire [31:0] data_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .rw(rw),
        .data_out(data_out),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rw = 0;
            addr = 0;
            data_in = 0;

            repeat (2) @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Cold Read Miss", test_num);
            reset_dut();


            rw = 0;
            addr = 16'h1234;
            @(negedge clk);



            #1;




            check_outputs(data_out, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write and Read Hit", test_num);
            reset_dut();


            rw = 1;
            addr = 16'hA0A0;
            data_in = 32'hDEADBEEF;
            @(negedge clk);


            rw = 0;
            addr = 16'hA0A0;
            @(negedge clk);


            #1;



            check_outputs(32'hDEADBEEF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Overwrite and Read Hit", test_num);
            reset_dut();


            rw = 1;
            addr = 16'h5555;
            data_in = 32'h11112222;
            @(negedge clk);


            rw = 1;
            addr = 16'h5555;
            data_in = 32'h33334444;
            @(negedge clk);


            rw = 0;
            addr = 16'h5555;
            @(negedge clk);

            #1;


            check_outputs(32'h33334444, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiple Address Persistence", test_num);
            reset_dut();


            rw = 1;
            addr = 16'h0001;
            data_in = 32'hAAAA_AAAA;
            @(negedge clk);


            rw = 1;
            addr = 16'h0002;
            data_in = 32'hBBBB_BBBB;
            @(negedge clk);


            rw = 0;
            addr = 16'h0001;
            @(negedge clk);


            #1;



            check_outputs(32'hAAAA_AAAA, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Interleaved Read/Write", test_num);
            reset_dut();


            rw = 1; addr = 16'hC0DE; data_in = 32'h12345678;
            @(negedge clk);


            rw = 0; addr = 16'hC0DE;
            @(negedge clk);


            rw = 1; addr = 16'hBEEF; data_in = 32'h87654321;
            @(negedge clk);


            rw = 0; addr = 16'hBEEF;
            @(negedge clk);

            #1;


            check_outputs(32'h87654321, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [31:0] expected_data_out;
        input expected_valid;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, valid=%b",
                         data_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, valid=%b",
                         expected_data_out, expected_valid);
                $display("  Got:      data_out=%h, valid=%b",
                         data_out, valid);
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
        $dumpvars(0,addr, clk, data_in, rw, data_out, valid);
    end

endmodule
