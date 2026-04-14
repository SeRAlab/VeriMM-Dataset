`timescale 1ns/1ps

module memory_arbiter_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [3:0] REQ;
    reg RST;
    wire GRANT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_arbiter dut (
        .CLK(CLK),
        .REQ(REQ),
        .RST(RST),
        .GRANT(GRANT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            REQ = 4'b0000;
            @(posedge CLK);
            #1 RST = 0;
            @(posedge CLK);
            test_num = test_num + 1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase 001: Reset and Idle");
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase 002: Single Request (REQ0)");
            REQ = 4'b0001;
            @(posedge CLK);
            #1 #1;
 check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Testcase 003: Round-Robin (REQ0 and REQ1)");
            REQ = 4'b0011;

            @(posedge CLK); #1;
            if (GRANT == 4'b0001) begin
                @(posedge CLK); #1;
                #1;

                check_outputs(4'b0010);
            end else if (GRANT == 4'b0010) begin
                @(posedge CLK); #1;
                #1;

                check_outputs(4'b0001);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: No valid grant for REQ0 or REQ1");
            end
        end
        endtask

    task testcase004;

        reg [3:0] sequence;
        begin
            reset_dut();
            $display("Testcase 004: Full Round-Robin Cycle (All REQs)");
            REQ = 4'b1111;
            sequence = 4'b0000;

            repeat(4) begin
                @(posedge CLK);
                #1 sequence = sequence | GRANT;
            end


            if (sequence == 4'b1111) begin
                pass_count = pass_count + 1;
                $display("PASS: All requests served in 4 cycles.");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Not all requests served. Sequence map: %b", sequence);
            end
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Testcase 005: Consecutive Grant Constraint");
            REQ = 4'b0100;

            @(posedge CLK); #1;
            if (GRANT == 4'b0100) begin
                @(posedge CLK); #1;


                if (GRANT == 4'b0100) begin
                    $display("FAIL: REQ2 granted twice in a row.");
                    fail_count = fail_count + 1;
                end else begin
                    $display("PASS: REQ2 not granted twice in a row.");
                    pass_count = pass_count + 1;
                end
            end else begin
                $display("FAIL: REQ2 never granted.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            $display("Testcase 006: Dynamic Request Change");
            REQ = 4'b1000;
            @(posedge CLK); #1;

            REQ = 4'b0001;
            @(posedge CLK); #1;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("memory_arbiter Testbench");
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
        input expected_GRANT;
        begin
            if (expected_GRANT === (expected_GRANT ^ GRANT ^ expected_GRANT)) begin
                $display("PASS");
                $display("  Outputs: GRANT=%b",
                         GRANT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: GRANT=%b",
                         expected_GRANT);
                $display("  Got:      GRANT=%b",
                         GRANT);
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
        $dumpvars(0,CLK, REQ, RST, GRANT);
    end

endmodule
