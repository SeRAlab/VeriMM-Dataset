`timescale 1ns/1ps

module ARQ_System_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg parity_in;
    reg rst;
    wire ack;
    wire req;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ_System dut (
        .clk(clk),
        .data_in(data_in),
        .parity_in(parity_in),
        .rst(rst),
        .ack(ack),
        .req(req)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 8'b0;
            parity_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All zeros (Valid Even Parity)", test_num);
            reset_dut();
            data_in = 8'h00;
            parity_in = 0;
            @(posedge clk);
            #2 #1;
 check_outputs(1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single bit set, no parity (Invalid)", test_num);
            reset_dut();
            data_in = 8'h01;
            parity_in = 0;
            @(posedge clk);
            #2 #1;
 check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single bit set with parity (Valid)", test_num);
            reset_dut();
            data_in = 8'h01;
            parity_in = 1;
            @(posedge clk);
            #2 #1;
 check_outputs(1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All ones (Valid Even Parity)", test_num);
            reset_dut();
            data_in = 8'hFF;
            parity_in = 0;
            @(posedge clk);
            #2 #1;
 check_outputs(1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All ones with parity bit (Invalid)", test_num);
            reset_dut();
            data_in = 8'hFF;
            parity_in = 1;
            @(posedge clk);
            #2 #1;
 check_outputs(0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating pattern AA (Valid)", test_num);
            reset_dut();
            data_in = 8'hAA;
            parity_in = 0;
            @(posedge clk);
            #2 #1;
 check_outputs(1, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Random pattern with parity error (Invalid)", test_num);
            reset_dut();
            data_in = 8'h12;
            parity_in = 1;
            @(posedge clk);
            #2 #1;
 check_outputs(0, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Recovery check", test_num);
            reset_dut();

            data_in = 8'h01; parity_in = 0;
            @(posedge clk);
            #1;

            data_in = 8'h01; parity_in = 1;
            @(posedge clk);
            #2 #1;
 check_outputs(1, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ARQ_System Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input expected_ack;
        input expected_req;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_req === (expected_req ^ req ^ expected_req)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, req=%b",
                         ack, req);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, req=%b",
                         expected_ack, expected_req);
                $display("  Got:      ack=%b, req=%b",
                         ack, req);
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
        $dumpvars(0,clk, data_in, parity_in, rst, ack, req);
    end

endmodule
