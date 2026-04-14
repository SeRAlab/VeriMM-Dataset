`timescale 1ns/1ps

module SRAM_8bit_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] D;
    reg WE;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_8bit dut (
        .CLK(CLK),
        .D(D),
        .WE(WE),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            WE = 0;
            D = 8'h00;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            WE = 1;
            D = 8'hA5;
            @(posedge CLK);
            #1;
            WE = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            WE = 1;
            D = 8'h5A;
            @(posedge CLK);
            #1;
            WE = 0;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;

            WE = 1;
            D = 8'hFF;
            @(posedge CLK);
            #1;

            WE = 0;
            D = 8'h00;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            WE = 1;
            D = 8'h00;
            @(posedge CLK);
            #1;
            WE = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            WE = 1;
            D = 8'hFF;
            @(posedge CLK);
            #1;
            WE = 0;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            WE = 1;
            D = 8'h3C;
            @(posedge CLK);
            #1;
            WE = 0;
            D = 8'hZZ;
            repeat(3) @(posedge CLK);
            #1;
            #1;

            check_outputs(8'h3C);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM_8bit Testbench");
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
        $dumpvars(0,CLK, D, WE, Q);
    end

endmodule
