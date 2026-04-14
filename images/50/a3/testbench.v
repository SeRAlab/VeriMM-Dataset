`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg RX_ECP;
    reg RX_PAD;
    reg [15:0] RX_PE_DATA;
    reg RX_PE_DATA_V;
    reg RX_SCP;
    reg START_RX;
    reg USER_CLK;
    wire [15:0] RX_D;
    wire RX_SRC_RDY_N;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RX_ECP(RX_ECP),
        .RX_PAD(RX_PAD),
        .RX_PE_DATA(RX_PE_DATA),
        .RX_PE_DATA_V(RX_PE_DATA_V),
        .RX_SCP(RX_SCP),
        .START_RX(START_RX),
        .USER_CLK(USER_CLK),
        .RX_D(RX_D),
        .RX_SRC_RDY_N(RX_SRC_RDY_N)
    );

    // Clock generation (10ns period)
    initial begin
        USER_CLK = 0;
        forever #5 USER_CLK = ~USER_CLK;
    end

        task reset_dut;

        begin
            START_RX = 0;
            RX_PE_DATA_V = 0;
            RX_PE_DATA = 16'h0;
            RX_SCP = 0;
            RX_ECP = 0;
            RX_PAD = 0;
            @(posedge USER_CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %03d: Basic Data Valid", test_num);
            START_RX = 1;
            RX_PE_DATA_V = 1;
            RX_PE_DATA = 16'hABCD;
            @(posedge USER_CLK);
            #2;

            #1;


            check_outputs(16'hABCD, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %03d: Data Invalid (Ready High)", test_num);
            START_RX = 1;
            RX_PE_DATA_V = 0;
            RX_PE_DATA = 16'hFFFF;
            @(posedge USER_CLK);
            #2;

            #1;


            check_outputs(RX_D, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %03d: SCP Signal Asserted", test_num);
            START_RX = 1;
            RX_PE_DATA_V = 1;
            RX_SCP = 1;
            RX_PE_DATA = 16'h5555;
            @(posedge USER_CLK);
            #2;
            #1;

            check_outputs(16'h5555, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %03d: ECP Signal Asserted", test_num);
            START_RX = 1;
            RX_PE_DATA_V = 1;
            RX_ECP = 1;
            RX_PE_DATA = 16'hEEEE;
            @(posedge USER_CLK);
            #2;
            #1;

            check_outputs(16'hEEEE, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %03d: PAD Signal Asserted", test_num);
            START_RX = 1;
            RX_PE_DATA_V = 1;
            RX_PAD = 1;
            RX_PE_DATA = 16'h0000;
            @(posedge USER_CLK);
            #2;
            #1;

            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Testcase %03d: START_RX Disabled", test_num);
            START_RX = 0;
            RX_PE_DATA_V = 1;
            RX_PE_DATA = 16'h1234;
            @(posedge USER_CLK);
            #2;

            #1;


            check_outputs(RX_D, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            $display("Testcase %03d: Sequential Burst", test_num);
            START_RX = 1;
            RX_PE_DATA_V = 1;
            RX_PE_DATA = 16'h1111;
            @(posedge USER_CLK);
            #1;
            RX_PE_DATA = 16'h2222;
            @(posedge USER_CLK);
            #1;
            RX_PE_DATA = 16'h3333;
            @(posedge USER_CLK);
            #2;
            #1;

            check_outputs(16'h3333, 1'b0);
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
        input [15:0] expected_RX_D;
        input expected_RX_SRC_RDY_N;
        begin
            if (expected_RX_D === (expected_RX_D ^ RX_D ^ expected_RX_D) &&
                expected_RX_SRC_RDY_N === (expected_RX_SRC_RDY_N ^ RX_SRC_RDY_N ^ expected_RX_SRC_RDY_N)) begin
                $display("PASS");
                $display("  Outputs: RX_D=%h, RX_SRC_RDY_N=%b",
                         RX_D, RX_SRC_RDY_N);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RX_D=%h, RX_SRC_RDY_N=%b",
                         expected_RX_D, expected_RX_SRC_RDY_N);
                $display("  Got:      RX_D=%h, RX_SRC_RDY_N=%b",
                         RX_D, RX_SRC_RDY_N);
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
        $dumpvars(0,RX_ECP, RX_PAD, RX_PE_DATA, RX_PE_DATA_V, RX_SCP, START_RX, USER_CLK, RX_D, RX_SRC_RDY_N);
    end

endmodule
