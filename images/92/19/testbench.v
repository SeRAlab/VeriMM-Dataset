`timescale 1ns/1ps

module register_8bit_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] D;
    reg LOAD;
    reg RESET;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_8bit dut (
        .CLK(CLK),
        .D(D),
        .LOAD(LOAD),
        .RESET(RESET),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RESET = 1;
            LOAD = 0;
            D = 0;
            #12;
            RESET = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Power-on Reset check");
            test_num = 1;
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Loading 8'hA5 with LOAD=1");
            test_num = 2;
            reset_dut();
            @(posedge CLK);
            D <= 8'hA5;
            LOAD <= 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Verify data hold when LOAD=0");
            test_num = 3;
            reset_dut();

            @(posedge CLK);
            D <= 8'h55;
            LOAD <= 1;
            @(posedge CLK);

            D <= 8'hFF;
            LOAD <= 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Asynchronous Reset mid-cycle override");
            test_num = 4;
            reset_dut();

            @(posedge CLK);
            D <= 8'hAA;
            LOAD <= 1;
            @(posedge CLK);
            #1;

            #3;
            RESET = 1;
            #1;
            #1;

            check_outputs(8'h00);
            RESET = 0;
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Loading maximum value 8'hFF");
            test_num = 5;
            reset_dut();
            @(posedge CLK);
            D <= 8'hFF;
            LOAD <= 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Consecutive loads of different values");
            test_num = 6;
            reset_dut();
            @(posedge CLK);
            LOAD <= 1;
            D <= 8'h11;
            @(posedge CLK);
            D <= 8'h22;
            @(posedge CLK);
            D <= 8'h33;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'h33);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register_8bit Testbench");
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
        $dumpvars(0,CLK, D, LOAD, RESET, Q);
    end

endmodule
