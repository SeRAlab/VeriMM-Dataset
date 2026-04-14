`timescale 1ns/1ps

module SRAM_Cell_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] D;
    reg RE;
    reg WE;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_Cell dut (
        .D(D),
        .RE(RE),
        .WE(WE),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        RE = 0;
        forever #5 RE = ~RE;
    end

        task reset_dut;

        begin
            WE = 1;
            D = 8'h00;
            #10;
            WE = 0;
            D = 8'h00;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %03d: Basic Write and Read (0xAA)", test_num);
            reset_dut();

            WE = 1;
            D = 8'hAA;
            #10;
            WE = 0;


            @(posedge RE);
            #2;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %03d: Basic Write and Read (0x55)", test_num);
            reset_dut();

            WE = 1;
            D = 8'h55;
            #10;
            WE = 0;

            @(posedge RE);
            #2;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %03d: Verify data persistence when WE is low", test_num);
            reset_dut();


            WE = 1;
            D = 8'hCC;
            #10;


            WE = 0;
            D = 8'h33;
            #10;


            @(posedge RE);
            #2;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %03d: Overwriting existing data", test_num);
            reset_dut();

            WE = 1;
            D = 8'h11;
            #10;
            D = 8'h22;
            #10;
            WE = 0;

            @(posedge RE);
            #2;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %03d: Writing and Reading 0xFF", test_num);
            reset_dut();

            WE = 1;
            D = 8'hFF;
            #10;
            WE = 0;

            @(posedge RE);
            #2;
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
        $display("SRAM_Cell Testbench");
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
        $dumpvars(0,D, RE, WE, Q);
    end

endmodule
