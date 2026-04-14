`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [8:0] addr_a;
    reg [8:0] addr_b;
    reg clk;
    reg [1:0] data_b;
    reg we_b;
    wire [1:0] q_a;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_a(addr_a),
        .addr_b(addr_b),
        .clk(clk),
        .data_b(data_b),
        .we_b(we_b),
        .q_a(q_a)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we_b = 0;
            addr_a = 0;
            addr_b = 0;
            data_b = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Write/Read Addr 0", test_num);
            reset_dut();


            @(posedge clk);
            we_b <= 1; addr_b <= 9'd0; data_b <= 2'b11;
            @(posedge clk);
            we_b <= 0;


            addr_a <= 9'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Boundary Addr 299", test_num);
            reset_dut();


            @(posedge clk);
            we_b <= 1; addr_b <= 9'd299; data_b <= 2'b01;
            @(posedge clk);
            we_b <= 0;


            addr_a <= 9'd299;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Write Enable Check", test_num);
            reset_dut();


            @(posedge clk);
            we_b <= 1; addr_b <= 9'd150; data_b <= 2'b10;
            @(posedge clk);

            we_b <= 0; addr_b <= 9'd150; data_b <= 2'b00;
            @(posedge clk);


            addr_a <= 9'd150;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Overwrite Check", test_num);
            reset_dut();


            @(posedge clk);
            we_b <= 1; addr_b <= 9'd75; data_b <= 2'b01;
            @(posedge clk);

            we_b <= 1; addr_b <= 9'd75; data_b <= 2'b11;
            @(posedge clk);
            we_b <= 0;


            addr_a <= 9'd75;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Simultaneous Read/Write", test_num);
            reset_dut();


            @(posedge clk);
            we_b <= 1; addr_b <= 9'd10; data_b <= 2'b10;
            @(posedge clk);


            we_b <= 1; addr_b <= 9'd20; data_b <= 2'b01;
            addr_a <= 9'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Persistence Check", test_num);
            reset_dut();

            @(posedge clk);
            we_b <= 1; addr_b <= 9'd42; data_b <= 2'b11;
            @(posedge clk);
            we_b <= 0;
            repeat (5) @(posedge clk);

            addr_a <= 9'd42;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b11);
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
        input [1:0] expected_q_a;
        begin
            if (expected_q_a === (expected_q_a ^ q_a ^ expected_q_a)) begin
                $display("PASS");
                $display("  Outputs: q_a=%h",
                         q_a);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q_a=%h",
                         expected_q_a);
                $display("  Got:      q_a=%h",
                         q_a);
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
        $dumpvars(0,addr_a, addr_b, clk, data_b, we_b, q_a);
    end

endmodule
