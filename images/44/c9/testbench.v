`timescale 1ns/1ps

module register_4bit_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [3:0] D;
    reg LOAD;
    reg RST;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_4bit dut (
        .CLK(CLK),
        .D(D),
        .LOAD(LOAD),
        .RST(RST),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        RST = 1;
        D = 4'h0;
        LOAD = 0;
        #15;
        RST = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Load Operation (D=4'hA, LOAD=1)", test_num);
        reset_dut();

        @(negedge CLK);
        D = 4'hA;
        LOAD = 1;

        @(posedge CLK);
        #2;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Load Disable (D=4'h5, LOAD=0)", test_num);
        reset_dut();

        @(negedge CLK);
        D = 4'h5;
        LOAD = 0;

        @(posedge CLK);
        #2;

        #1;


        check_outputs(4'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Asynchronous Reset Priority during Load", test_num);
        reset_dut();

        @(negedge CLK);
        D = 4'hF;
        LOAD = 1;

        @(posedge CLK);
        #2;


        #2;
        RST = 1;
        #1;
        #1;

        check_outputs(4'h0);
        RST = 0;
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Data Retention (Load 4'h7, then disable LOAD)", test_num);
        reset_dut();


        @(negedge CLK);
        D = 4'h7;
        LOAD = 1;
        @(posedge CLK);


        @(negedge CLK);
        D = 4'hE;
        LOAD = 0;
        @(posedge CLK);

        #2;

        #1;


        check_outputs(4'h7);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Load 4'hF (Boundary Test)", test_num);
        reset_dut();

        @(negedge CLK);
        D = 4'hF;
        LOAD = 1;

        @(posedge CLK);
        #2;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sequential Loads (4'h3 -> 4'hC)", test_num);
        reset_dut();

        @(negedge CLK);
        D = 4'h3;
        LOAD = 1;
        @(posedge CLK);

        @(negedge CLK);
        D = 4'hC;
        LOAD = 1;
        @(posedge CLK);

        #2;
        #1;

        check_outputs(4'hC);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register_4bit Testbench");
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
        input [3:0] expected_Q;
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
        $dumpvars(0,CLK, D, LOAD, RST, Q);
    end

endmodule
