`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] addr_in;
    reg clk;
    reg [127:0] data_in;
    reg data_re_in;
    reg data_we_in;
    reg [5:0] state_in;
    reg state_re_in;
    reg state_we_in;
    wire [127:0] data_out;
    wire [5:0] state_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_in(addr_in),
        .clk(clk),
        .data_in(data_in),
        .data_re_in(data_re_in),
        .data_we_in(data_we_in),
        .state_in(state_in),
        .state_re_in(state_re_in),
        .state_we_in(state_we_in),
        .data_out(data_out),
        .state_out(state_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr_in = 0;
            data_in = 0;
            data_re_in = 0;
            data_we_in = 0;
            state_in = 0;
            state_re_in = 0;
            state_we_in = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic State Write/Read");
            reset_dut();


            addr_in = 32'h10;
            state_in = 6'h2A;
            state_we_in = 1;
            @(posedge clk);
            state_we_in = 0;


            state_re_in = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(128'h0, 6'h2A);
        end
        endtask

    task testcase002;

        reg [127:0] test_val;
        begin
            $display("Testcase 002: Basic Data Write/Read");
            reset_dut();
            test_val = 128'hDEADBEEF_CAFEF00D_12345678_87654321;


            addr_in = 32'h20;
            data_in = test_val;
            data_we_in = 1;
            @(posedge clk);
            data_we_in = 0;


            data_re_in = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(test_val, 6'h0);
        end
        endtask

    task testcase003;

        reg [127:0] test_val;
        begin
            $display("Testcase 003: Simultaneous Write/Read");
            reset_dut();
            test_val = 128'hFFFFFFFF_00000000_AAAA_5555;


            addr_in = 32'h5;
            state_in = 6'h3F;
            data_in = test_val;
            state_we_in = 1;
            data_we_in = 1;
            @(posedge clk);
            state_we_in = 0;
            data_we_in = 0;


            state_re_in = 1;
            data_re_in = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(test_val, 6'h3F);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Independence check");
            reset_dut();


            addr_in = 32'hA;
            state_in = 6'h12;
            state_we_in = 1;
            @(posedge clk);


            addr_in = 32'hB;
            data_in = 128'hC0FFEE;
            data_we_in = 1;
            state_we_in = 0;
            @(posedge clk);
            data_we_in = 0;



            addr_in = 32'hA;
            state_re_in = 1;
            data_re_in = 0;
            @(posedge clk);



            #1;
            if (state_out !== 6'h12) $display("Error: State at A wrong");


            addr_in = 32'hB;
            data_re_in = 1;
            state_re_in = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(128'hC0FFEE, 6'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Read Enable behavior");
            reset_dut();


            addr_in = 32'h100;
            data_in = 128'h1;
            data_we_in = 1;
            @(posedge clk);
            data_we_in = 0;


            data_re_in = 0;
            @(posedge clk);
            #1;




            #1;





            check_outputs(128'h0, 6'h0);
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
        input [127:0] expected_data_out;
        input [5:0] expected_state_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_state_out === (expected_state_out ^ state_out ^ expected_state_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, state_out=%h",
                         data_out, state_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, state_out=%h",
                         expected_data_out, expected_state_out);
                $display("  Got:      data_out=%h, state_out=%h",
                         data_out, state_out);
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
        $dumpvars(0,addr_in, clk, data_in, data_re_in, data_we_in, state_in, state_re_in, state_we_in, data_out, state_out);
    end

endmodule
