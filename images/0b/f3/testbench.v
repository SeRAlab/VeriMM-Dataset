`timescale 1ns/1ps

module eeprom_cell_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [3:0] D;
    reg RW;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eeprom_cell dut (
        .CLK(CLK),
        .D(D),
        .RW(RW),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        D <= 4'b0;
        RW <= 1'b0;
        @(posedge CLK);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Write and Read pattern 4'hA", test_num);


        RW = 1;
        D = 4'hA;
        @(posedge CLK);
        #1;


        RW = 0;
        D = 4'h0;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(4'hA);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Write and Read pattern 4'h5", test_num);


        RW = 1;
        D = 4'h5;
        @(posedge CLK);
        #1;


        RW = 0;
        D = 4'hF;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(4'h5);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Verify data persistence (RW=0 blocks writes)", test_num);


        RW = 1;
        D = 4'hC;
        @(posedge CLK);
        #1;


        RW = 0;
        D = 4'h3;
        @(posedge CLK);
        #1;

        D = 4'hE;
        @(posedge CLK);
        #1;


        #1;



        check_outputs(4'hC);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary Check - All Ones (4'hF)", test_num);

        RW = 1;
        D = 4'hF;
        @(posedge CLK);
        #1;

        RW = 0;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(4'hF);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Overwriting existing data", test_num);


        RW = 1;
        D = 4'h7;
        @(posedge CLK);
        #1;


        RW = 1;
        D = 4'h2;
        @(posedge CLK);
        #1;

        RW = 0;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(4'h2);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("eeprom_cell Testbench");
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
        $dumpvars(0,CLK, D, RW, Q);
    end

endmodule
