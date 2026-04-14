`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg request1;
    reg request2;
    reg reset;
    wire busy;
    wire [7:0] data;
    wire grant;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .request1(request1),
        .request2(request2),
        .reset(reset),
        .busy(busy),
        .data(data),
        .grant(grant)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            request1 = 0;
            request2 = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Idle State Check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Channel 1 Request", test_num);
            reset_dut();
            request1 = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, data, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Channel 2 Request", test_num);
            reset_dut();
            request2 = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, data, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Priority Test (Req1 and Req2)", test_num);
            reset_dut();
            request1 = 1;
            request2 = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, data, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Preemption/Priority Sequence", test_num);
            reset_dut();

            request2 = 1;
            @(posedge clk);
            #1;

            request1 = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, data, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Releasing Requests", test_num);
            reset_dut();
            request1 = 1;
            @(posedge clk);
            #1;
            request1 = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 8'h00, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
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
        input expected_busy;
        input [7:0] expected_data;
        input expected_grant;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_data === (expected_data ^ data ^ expected_data) &&
                expected_grant === (expected_grant ^ grant ^ expected_grant)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, data=%h, grant=%b",
                         busy, data, grant);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, data=%h, grant=%b",
                         expected_busy, expected_data, expected_grant);
                $display("  Got:      busy=%b, data=%h, grant=%b",
                         busy, data, grant);
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
        $dumpvars(0,clk, request1, request2, reset, busy, data, grant);
    end

endmodule
