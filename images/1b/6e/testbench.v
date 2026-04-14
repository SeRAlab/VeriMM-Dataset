`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg [3:0] req;
    reg reset;
    wire busy;
    wire [7:0] data_out;
    wire [3:0] grant;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .data_in(data_in),
        .req(req),
        .reset(reset),
        .busy(busy),
        .data_out(data_out),
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
            req = 4'b0000;
            data_in = 8'h00;
            #20;
            reset = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Reset State Check");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b0, 8'h00, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Channel 0 Request");
            test_num = 2;
            reset_dut();
            @(posedge clk);
            req = 4'b0001;
            data_in = 8'hA5;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 8'hA5, 4'b0001);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Channel 3 Request");
            test_num = 3;
            reset_dut();
            @(posedge clk);
            req = 4'b1000;
            data_in = 8'h5A;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 8'h5A, 4'b1000);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Priority Check (Ch0 vs Ch1)");
            test_num = 4;
            reset_dut();
            @(posedge clk);
            req = 4'b0011;
            data_in = 8'h11;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 8'h11, 4'b0001);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Priority Check (Ch1 vs Ch3)");
            test_num = 5;
            reset_dut();
            @(posedge clk);
            req = 4'b1010;
            data_in = 8'hB2;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 8'hB2, 4'b0010);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Return to IDLE when req is dropped");
            test_num = 6;
            reset_dut();
            @(posedge clk);
            req = 4'b0100;
            data_in = 8'hFF;
            repeat(2) @(posedge clk);
            req = 4'b0000;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b0, 8'h00, 4'b0000);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning testcase007: Simultaneous All-Channel Request");
            test_num = 7;
            reset_dut();
            @(posedge clk);
            req = 4'b1111;
            data_in = 8'h88;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 8'h88, 4'b0001);
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
        testcase007();
        
        
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
        input [7:0] expected_data_out;
        input [3:0] expected_grant;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_grant === (expected_grant ^ grant ^ expected_grant)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, data_out=%h, grant=%h",
                         busy, data_out, grant);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, data_out=%h, grant=%h",
                         expected_busy, expected_data_out, expected_grant);
                $display("  Got:      busy=%b, data_out=%h, grant=%h",
                         busy, data_out, grant);
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
        $dumpvars(0,clk, data_in, req, reset, busy, data_out, grant);
    end

endmodule
