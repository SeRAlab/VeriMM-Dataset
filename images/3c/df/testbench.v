`timescale 1ns/1ps

module SRAM_Cell_tb;

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
    SRAM_Cell dut (
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
            WE <= 1'b1;
            D <= 8'h00;
            @(posedge CLK);
            #1;
            WE <= 1'b0;
            D <= 8'h00;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read (0xAA)", test_num);
            reset_dut();


            @(negedge CLK);
            WE = 1;
            D = 8'hAA;
            @(posedge CLK);
            #1;
            WE = 0;
            D = 8'h00;


            #1;



            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read (0x55)", test_num);
            reset_dut();


            @(negedge CLK);
            WE = 1;
            D = 8'h55;
            @(posedge CLK);
            #1;
            WE = 0;
            D = 8'hFF;


            #1;



            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No Write when WE is low", test_num);
            reset_dut();


            @(negedge CLK);
            WE = 0;
            D = 8'hEE;
            @(posedge CLK);
            #1;


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data persistence over multiple cycles", test_num);
            reset_dut();


            @(negedge CLK);
            WE = 1;
            D = 8'h12;
            @(posedge CLK);
            #1;
            WE = 0;


            repeat(3) @(posedge CLK);
            #1;


            #1;



            check_outputs(8'h12);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Consecutive writes", test_num);
            reset_dut();


            @(negedge CLK);
            WE = 1;
            D = 8'h11;
            @(posedge CLK);
            #1;

            D = 8'h22;
            @(posedge CLK);
            #1;
            WE = 0;


            #1;



            check_outputs(8'h22);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write all ones (0xFF)", test_num);
            reset_dut();

            @(negedge CLK);
            WE = 1;
            D = 8'hFF;
            @(posedge CLK);
            #1;
            WE = 0;

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
