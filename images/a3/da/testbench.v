`timescale 1ns/1ps

module reg_8bit_async_reset_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] D;
    reg RST;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg_8bit_async_reset dut (
        .CLK(CLK),
        .D(D),
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
            RST = 1;
            D = 0;
            #12;
            RST = 0;
            @(negedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %03d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %03d: Load 8'hAA", test_num);
            reset_dut();
            D = 8'hAA;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %03d: Load 8'h55", test_num);
            reset_dut();
            D = 8'h55;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %03d: Asynchronous Reset Mid-Cycle", test_num);
            reset_dut();
            D = 8'hFF;
            @(posedge CLK);
            #2;


            #3;
            RST = 1;
            #1;
            #1;

            check_outputs(8'h00);
            RST = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %03d: Sequential Load and Hold", test_num);
            reset_dut();
            D = 8'h12;
            @(posedge CLK);
            #1;
            D = 8'h34;
            @(posedge CLK);
            #1;
            D = 8'h56;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(8'h56);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %03d: All Bits High (0xFF)", test_num);
            reset_dut();
            D = 8'hFF;
            @(posedge CLK);
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
        $display("reg_8bit_async_reset Testbench");
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
        $dumpvars(0,CLK, D, RST, Q);
    end

endmodule
