`timescale 1ns/1ps

module sram_cell_tb;

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
    sram_cell dut (
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


        WE = 0;
        D = 8'h00;
        @(posedge RE);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Basic Write and Read (0xA5)", test_num);
        reset_dut();


        WE = 1; D = 8'hA5;
        @(posedge RE);


        WE = 0;
        @(posedge RE);
        #2;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Basic Write and Read (0x5A)", test_num);
        reset_dut();


        WE = 1; D = 8'h5A;
        @(posedge RE);


        WE = 0;
        @(posedge RE);
        #2;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Data Retention (WE low, change D)", test_num);
        reset_dut();


        WE = 1; D = 8'hFF;
        @(posedge RE);


        WE = 0; D = 8'h00;
        @(posedge RE);


        #2;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Overwrite Operation", test_num);
        reset_dut();


        WE = 1; D = 8'h11;
        @(posedge RE);


        WE = 1; D = 8'h22;
        @(posedge RE);


        WE = 0;
        @(posedge RE);
        #2;
        #1;

        check_outputs(8'h22);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: All Zeros Write/Read", test_num);
        reset_dut();

        WE = 1; D = 8'h00;
        @(posedge RE);

        WE = 0;
        @(posedge RE);
        #2;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: All Ones Write/Read", test_num);
        reset_dut();

        WE = 1; D = 8'hFF;
        @(posedge RE);

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
        $display("sram_cell Testbench");
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
        $dumpvars(0,D, RE, WE, Q);
    end

endmodule
