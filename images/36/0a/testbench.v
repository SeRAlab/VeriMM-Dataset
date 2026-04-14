`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [3:0] D;
    reg RE;
    reg WE;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .CLK(CLK),
        .D(D),
        .RE(RE),
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
            RE = 0;
            D = 4'h0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Basic Write and Read (0xA)", test_num);


            WE = 1;
            D = 4'hA;
            @(posedge CLK);
            #1;
            WE = 0;


            RE = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'hA);
            RE = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Basic Write and Read (0x5)", test_num);


            WE = 1;
            D = 4'h5;
            @(posedge CLK);
            #1;
            WE = 0;


            RE = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'h5);
            RE = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Write Enable Control Check", test_num);


            WE = 1;
            D = 4'hC;
            @(posedge CLK);
            #1;


            WE = 0;
            D = 4'h3;
            @(posedge CLK);
            #1;


            RE = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'hC);
            RE = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Boundary Value 0xF", test_num);

            WE = 1;
            D = 4'hF;
            @(posedge CLK);
            #1;
            WE = 0;
            RE = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'hF);
            RE = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Boundary Value 0x0", test_num);

            WE = 1;
            D = 4'h0;
            @(posedge CLK);
            #1;
            WE = 0;
            RE = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(4'h0);
            RE = 0;
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
        $dumpvars(0,CLK, D, RE, WE, Q);
    end

endmodule
