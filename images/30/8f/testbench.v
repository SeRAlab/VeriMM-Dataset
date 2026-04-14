`timescale 1ns/1ps

module PID_Controller_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] PV;
    reg [15:0] SP;
    reg clk;
    reg reset;
    wire [15:0] CV;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PID_Controller dut (
        .PV(PV),
        .SP(SP),
        .clk(clk),
        .reset(reset),
        .CV(CV)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        PV = 0;
        SP = 0;
        repeat(2) @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Zero Error", test_num);
        reset_dut();
        SP = 16'd100;
        PV = 16'd100;
        @(posedge clk);
        #1;

        #1;


        check_outputs(16'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Positive Step Response", test_num);
        reset_dut();
        SP = 16'd100;
        PV = 16'd50;
        @(posedge clk);
        #1;




        #1;





        check_outputs(16'h0096);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Integral Accumulation", test_num);
        reset_dut();
        SP = 16'd10;
        PV = 16'd0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'd40);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Negative Error", test_num);
        reset_dut();
        SP = 16'd50;
        PV = 16'd100;
        @(posedge clk);
        #1;




        #1;





        check_outputs(16'hFF6A);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Derivative Action (Damping)", test_num);
        reset_dut();


        SP = 16'd100;
        PV = 16'd20;
        @(posedge clk);



        PV = 16'd90;
        @(posedge clk);
        #1;




        #1;





        check_outputs(16'd30);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("PID_Controller Testbench");
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
        input [15:0] expected_CV;
        begin
            if (expected_CV === (expected_CV ^ CV ^ expected_CV)) begin
                $display("PASS");
                $display("  Outputs: CV=%h",
                         CV);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CV=%h",
                         expected_CV);
                $display("  Got:      CV=%h",
                         CV);
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
        $dumpvars(0,PV, SP, clk, reset, CV);
    end

endmodule
