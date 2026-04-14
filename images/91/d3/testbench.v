`timescale 1ns/1ps

module register_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] D;
    reg clk;
    reg load;
    reg reset;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register dut (
        .D(D),
        .clk(clk),
        .load(load),
        .reset(reset),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        load = 0;
        D = 8'h00;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Basic synchronous load", test_num);
        reset_dut();
        D = 8'hA5;
        load = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Load enable low", test_num);
        reset_dut();


        D = 8'h55;
        load = 1;
        @(posedge clk);
        #1;


        D = 8'hAA;
        load = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Reset priority", test_num);
        reset_dut();


        D = 8'hFF;
        load = 1;
        reset = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Sequential loads", test_num);
        reset_dut();


        D = 8'h12;
        load = 1;
        @(posedge clk);
        #1;


        D = 8'h34;
        load = 1;
        @(posedge clk);
        #1;


        D = 8'h56;
        load = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h56);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Data stability toggle", test_num);
        reset_dut();

        D = 8'hCC;
        load = 1;
        @(posedge clk);
        #1;

        load = 0;
        D = 8'h33;
        @(posedge clk);
        #1;

        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hCC);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register Testbench");
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
        input [7:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,D, clk, load, reset, Q);
    end

endmodule
