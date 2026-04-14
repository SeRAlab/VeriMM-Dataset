`timescale 1ns/1ps

module reg_8bit_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] D;
    reg EN;
    reg RST;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg_8bit dut (
        .CLK(CLK),
        .D(D),
        .EN(EN),
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
            @(negedge CLK);
            RST = 1;
            EN = 0;
            D = 8'h00;
            @(negedge CLK);
            RST = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Synchronous Reset", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Normal Load (EN=1)", test_num);
            reset_dut();
            @(negedge CLK);
            D = 8'hA5;
            EN = 1;
            @(negedge CLK);
            EN = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Hold Value (EN=0)", test_num);
            reset_dut();

            @(negedge CLK);
            D = 8'h55;
            EN = 1;
            @(negedge CLK);

            D = 8'hFF;
            EN = 0;
            @(negedge CLK);

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Priority", test_num);
            reset_dut();

            @(negedge CLK);
            D = 8'hAA;
            EN = 1;
            @(negedge CLK);

            D = 8'hBB;
            EN = 1;
            RST = 1;
            @(negedge CLK);
            RST = 0;
            EN = 0;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multi-cycle Data Loading", test_num);
            reset_dut();
            @(negedge CLK);
            EN = 1;
            D = 8'h10;
            @(negedge CLK);
            D = 8'h20;
            @(negedge CLK);
            D = 8'h30;
            @(negedge CLK);
            EN = 0;
            #1;

            check_outputs(8'h30);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg_8bit Testbench");
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
        $dumpvars(0,CLK, D, EN, RST, Q);
    end

endmodule
