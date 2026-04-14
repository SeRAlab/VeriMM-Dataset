`timescale 1ns/1ps

module fixed_priority_arbiter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg req0;
    reg req1;
    reg req2;
    wire grant;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fixed_priority_arbiter dut (
        .clk(clk),
        .en(en),
        .req0(req0),
        .req1(req1),
        .req2(req2),
        .grant(grant)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            en = 0;
            req0 = 0;
            req1 = 0;
            req2 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %03d: Request 0 only (Highest Priority)", test_num);
            reset_dut();
            en = 1;
            req0 = 1; req1 = 0; req2 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %03d: Request 1 only", test_num);
            reset_dut();
            en = 1;
            req0 = 0; req1 = 1; req2 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %03d: Request 2 only", test_num);
            reset_dut();
            en = 1;
            req0 = 0; req1 = 0; req2 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %03d: Simultaneous req0 and req1 (req0 wins)", test_num);
            reset_dut();
            en = 1;
            req0 = 1; req1 = 1; req2 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %03d: Simultaneous req1 and req2 (req1 wins)", test_num);
            reset_dut();
            en = 1;
            req0 = 0; req1 = 1; req2 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %03d: All requests active (req0 wins)", test_num);
            reset_dut();
            en = 1;
            req0 = 1; req1 = 1; req2 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %03d: Arbiter disabled with active requests", test_num);
            reset_dut();
            en = 0;
            req0 = 1; req1 = 1; req2 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %03d: No requests active", test_num);
            reset_dut();
            en = 1;
            req0 = 0; req1 = 0; req2 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %03d: Registration check (latency check)", test_num);
            reset_dut();
            en = 1;
            req0 = 1;
            #2;

            if (grant !== 3'b000) begin
                $display("FAIL: Grant changed before clock edge");
                fail_count = fail_count + 1;
            end else begin
                @(posedge clk);
                #1;
                #1;

                check_outputs(3'b001);
            end
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %03d: Priority override", test_num);
            reset_dut();
            en = 1;
            req2 = 1;
            @(posedge clk);
            #1;

            req0 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fixed_priority_arbiter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input expected_grant;
        begin
            if (expected_grant === (expected_grant ^ grant ^ expected_grant)) begin
                $display("PASS");
                $display("  Outputs: grant=%b",
                         grant);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: grant=%b",
                         expected_grant);
                $display("  Got:      grant=%b",
                         grant);
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
        $dumpvars(0,clk, en, req0, req1, req2, grant);
    end

endmodule
