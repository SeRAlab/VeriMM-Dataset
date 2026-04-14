`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [15:0] D;
    reg WE;
    wire [15:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
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
            WE <= 0;
            D <= 0;
            @(negedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Write and Read (0xABCD)", test_num);
            reset_dut();


            WE = 1;
            D = 16'hABCD;
            @(posedge CLK);


            #2;
            WE = 0;
            @(negedge CLK);

            #2;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Write and Read (0x1234)", test_num);
            reset_dut();

            WE = 1;
            D = 16'h1234;
            @(posedge CLK);

            #2;
            WE = 0;
            @(negedge CLK);

            #2;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: WE Low Prevention Test", test_num);
            reset_dut();


            WE = 1; D = 16'h5555;
            @(posedge CLK);
            #2; WE = 0; @(negedge CLK);


            #2;
            WE = 0;
            D = 16'hFFFF;
            @(posedge CLK);


            @(negedge CLK);
            #2;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Boundary Value 0xFFFF", test_num);
            reset_dut();

            WE = 1;
            D = 16'hFFFF;
            @(posedge CLK);

            #2;
            WE = 0;
            @(negedge CLK);

            #2;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Boundary Value 0x0000", test_num);
            reset_dut();

            WE = 1;
            D = 16'h0000;
            @(posedge CLK);

            #2;
            WE = 0;
            @(negedge CLK);

            #2;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Data Persistence", test_num);
            reset_dut();

            WE = 1;
            D = 16'hBEEF;
            @(posedge CLK);

            #2;
            WE = 0;

            repeat(3) @(negedge CLK);

            #2;
            #1;

            check_outputs(16'hBEEF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dram_cell Testbench");
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
        input [15:0] expected_Q;
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
