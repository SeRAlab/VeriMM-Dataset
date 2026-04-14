`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLKIN;
    reg RST;
    wire CLKFX;
    wire LOCKED;
    wire [7:0] STATUS;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLKIN(CLKIN),
        .RST(RST),
        .CLKFX(CLKFX),
        .LOCKED(LOCKED),
        .STATUS(STATUS)
    );

    // Clock generation (10ns period)
    initial begin
        CLKIN = 0;
        forever #5 CLKIN = ~CLKIN;
    end

        task reset_dut;

        begin
            RST = 1;
            repeat(5) @(posedge CLKIN);
            #1;
            RST = 0;
            @(posedge CLKIN);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset State Verification", test_num);
            RST = 1;
            repeat(2) @(posedge CLKIN);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 8'h00);
            RST = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Pre-Lock Initialization State", test_num);
            reset_dut();
            repeat(10) @(posedge CLKIN);
            #1;



            if (LOCKED === 1'b0) begin
                pass_count = pass_count + 1;
                $display("PASS: LOCKED is 0 during initialization.");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: LOCKED should be 0 during initialization.");
            end
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Lock Assertion Test", test_num);
            reset_dut();

            repeat(200) @(posedge CLKIN);
            #1;



            if (LOCKED === 1'b1) begin
                pass_count = pass_count + 1;
                $display("PASS: DCM achieved LOCKED status.");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: DCM failed to lock after 200 cycles.");
            end
        end
        endtask

    task testcase004;

        reg last_clkfx;
        begin
            test_num = 4;
            $display("Testcase %03d: CLKFX Toggling and Status Check", test_num);
            reset_dut();
            repeat(100) @(posedge CLKIN);

            last_clkfx = CLKFX;
            repeat(5) @(posedge CLKIN);


            if (CLKFX !== last_clkfx || LOCKED === 1'b1) begin
                $display("PASS: CLKFX toggling detected or Lock achieved.");
                pass_count = pass_count + 1;
            } else begin
                $display("FAIL: Clock output is static.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Re-assertion of Reset", test_num);
            reset_dut();
            repeat(200) @(posedge CLKIN);

            RST = 1;
            repeat(2) @(posedge CLKIN);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 8'h00);
            RST = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_CLKFX;
        input expected_LOCKED;
        input [7:0] expected_STATUS;
        begin
            if (expected_CLKFX === (expected_CLKFX ^ CLKFX ^ expected_CLKFX) &&
                expected_LOCKED === (expected_LOCKED ^ LOCKED ^ expected_LOCKED) &&
                expected_STATUS === (expected_STATUS ^ STATUS ^ expected_STATUS)) begin
                $display("PASS");
                $display("  Outputs: CLKFX=%b, LOCKED=%b, STATUS=%h",
                         CLKFX, LOCKED, STATUS);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CLKFX=%b, LOCKED=%b, STATUS=%h",
                         expected_CLKFX, expected_LOCKED, expected_STATUS);
                $display("  Got:      CLKFX=%b, LOCKED=%b, STATUS=%h",
                         CLKFX, LOCKED, STATUS);
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
        $dumpvars(0,CLKIN, RST, CLKFX, LOCKED, STATUS);
    end

endmodule
