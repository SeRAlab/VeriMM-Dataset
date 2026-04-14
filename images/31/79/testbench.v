`timescale 1ns/1ps

module dram_cell_tb;

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
            @(negedge CLK);
            WE = 1;
            D = 8'h00;
            @(negedge CLK);
            WE = 0;
            D = 8'h00;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write and Read (0xA5)", test_num);
            reset_dut();

            @(negedge CLK);
            WE = 1;
            D = 8'hA5;
            @(negedge CLK);
            WE = 0;
            D = 8'hFF;

            #2;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Data Retention with WE=0", test_num);
            reset_dut();


            @(negedge CLK);
            WE = 1;
            D = 8'h5A;
            @(negedge CLK);


            WE = 0;
            D = 8'h11; @(negedge CLK);
            D = 8'h22; @(negedge CLK);
            D = 8'h33; @(negedge CLK);

            #2;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Boundary Test (0xFF)", test_num);
            reset_dut();

            @(negedge CLK);
            WE = 1;
            D = 8'hFF;
            @(negedge CLK);
            WE = 0;

            #2;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Successive Writes", test_num);
            reset_dut();

            @(negedge CLK);
            WE = 1; D = 8'h12;
            @(negedge CLK);
            WE = 1; D = 8'h34;
            @(negedge CLK);
            WE = 1; D = 8'h56;
            @(negedge CLK);
            WE = 0;

            #2;
            #1;

            check_outputs(8'h56);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Pulse WE between edges", test_num);
            reset_dut();

            @(negedge CLK);
            WE = 1;
            D = 8'hCC;
            #2;
            WE = 0;

            @(negedge CLK);
            #2;

            #1;


            check_outputs(8'h00);
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
