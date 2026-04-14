`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] D;
    reg LOAD;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .CLK(CLK),
        .D(D),
        .LOAD(LOAD),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            LOAD = 1'b1;
            D = 8'h00;
            @(posedge CLK);
            #1;
            LOAD = 1'b0;
            D = 8'h00;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            LOAD = 1'b1;
            D = 8'hA5;
            @(posedge CLK);
            #1;
            $display("Testcase 001: Parallel Load 8'hA5");
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            LOAD = 1'b1;
            D = 8'h55;
            @(posedge CLK);
            #1;

            LOAD = 1'b0;
            @(posedge CLK);
            #1;
            $display("Testcase 002: Load 8'h55 and shift left once");
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            LOAD = 1'b1;
            D = 8'h01;
            @(posedge CLK);
            #1;

            LOAD = 1'b0;
            repeat(4) @(posedge CLK);
            #1;
            $display("Testcase 003: Load 8'h01 and shift left 4 times");
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            LOAD = 1'b1;
            D = 8'h80;
            @(posedge CLK);
            #1;

            LOAD = 1'b0;
            @(posedge CLK);
            #1;
            $display("Testcase 004: Shift out MSB (8'h80 -> 8'h00)");
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            LOAD = 1'b1;
            D = 8'hFF;
            @(posedge CLK);
            #1;

            LOAD = 1'b0;
            repeat(4) @(posedge CLK);
            #1;

            LOAD = 1'b1;
            D = 8'h33;
            @(posedge CLK);
            #1;
            $display("Testcase 005: Shift 4 times then perform a new Load 8'h33");
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            LOAD = 1'b1;
            D = 8'hFF;
            @(posedge CLK);
            #1;
            LOAD = 1'b0;
            repeat(8) @(posedge CLK);
            #1;
            $display("Testcase 006: Shift 8 times to empty register");
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
        $display("shift_register Testbench");
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
        $dumpvars(0,CLK, D, LOAD, Q);
    end

endmodule
