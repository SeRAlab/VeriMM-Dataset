`timescale 1ns/1ps

module register_8bit_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [7:0] D;
    reg Enable;
    reg Reset;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_8bit dut (
        .Clk(Clk),
        .D(D),
        .Enable(Enable),
        .Reset(Reset),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

    begin
        @(negedge Clk);
        Reset = 1;
        Enable = 0;
        D = 8'h00;
        @(negedge Clk);
        Reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify Synchronous Reset", test_num);
        reset_dut();


        #1;



        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Load (Enable=1)", test_num);
        reset_dut();
        @(negedge Clk);
        Enable = 1;
        D = 8'hA5;
        @(negedge Clk);
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Hold Data (Enable=0)", test_num);
        reset_dut();


        @(negedge Clk);
        Enable = 1;
        D = 8'h55;
        @(negedge Clk);


        Enable = 0;
        D = 8'hFF;
        @(negedge Clk);


        #1;



        check_outputs(8'h55);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset Priority over Enable", test_num);
        reset_dut();


        @(negedge Clk);
        Reset = 1;
        Enable = 1;
        D = 8'hFF;
        @(negedge Clk);


        #1;



        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Consecutive Data Loads", test_num);
        reset_dut();

        @(negedge Clk);
        Enable = 1;
        D = 8'h11;
        @(negedge Clk);
        D = 8'h22;
        @(negedge Clk);
        D = 8'h33;
        @(negedge Clk);

        #1;


        check_outputs(8'h33);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset from Non-Zero State", test_num);
        reset_dut();


        @(negedge Clk);
        Enable = 1;
        D = 8'hAA;
        @(negedge Clk);


        Reset = 1;
        @(negedge Clk);

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All bits high (0xFF)", test_num);
        reset_dut();

        @(negedge Clk);
        Enable = 1;
        D = 8'hFF;
        @(negedge Clk);

        #1;


        check_outputs(8'hFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register_8bit Testbench");
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
        $dumpvars(0,Clk, D, Enable, Reset, Q);
    end

endmodule
