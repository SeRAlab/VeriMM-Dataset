`timescale 1ns/1ps

module register_8bit_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg CLR;
    reg [7:0] D;
    reg LOAD;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_8bit dut (
        .CLK(CLK),
        .CLR(CLR),
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
            CLR = 1;
            LOAD = 0;
            D = 0;
            #10;
            CLR = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Loading 8'hA5 into register");
            reset_dut();
            @(negedge CLK);
            D = 8'hA5;
            LOAD = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Hold value (LOAD=0)");
            reset_dut();

            @(negedge CLK);
            D = 8'h55;
            LOAD = 1;
            @(posedge CLK);
            #2;

            @(negedge CLK);
            D = 8'hFF;
            LOAD = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Asynchronous Clear during operation");
            reset_dut();

            @(negedge CLK);
            D = 8'hFF;
            LOAD = 1;
            @(posedge CLK);
            #2;

            #3;
            CLR = 1;
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Loading 8'h00");
            reset_dut();
            @(negedge CLK);
            D = 8'h00;
            LOAD = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Consecutive multi-cycle loads");
            reset_dut();
            @(negedge CLK);
            D = 8'h12;
            LOAD = 1;
            @(posedge CLK);
            #2;
            @(negedge CLK);
            D = 8'h34;
            @(posedge CLK);
            #2;
            @(negedge CLK);
            D = 8'h56;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(8'h56);
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
        $dumpvars(0,CLK, CLR, D, LOAD, Q);
    end

endmodule
