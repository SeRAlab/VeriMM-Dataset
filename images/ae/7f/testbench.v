`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [47:0] address;
    reg clk;
    reg [7:0] data;
    reg go;
    reg reset;
    wire done;
    wire match;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clk(clk),
        .data(data),
        .go(go),
        .reset(reset),
        .done(done),
        .match(match)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            go = 0;
            data = 8'h00;
            address = 48'h0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Perfect Match...");
            reset_dut();
            address = 48'hAABBCCDDEEFF;

            @(posedge clk);
            #1 go = 1; data = 8'hAA;
            @(posedge clk);
            #1 go = 0; data = 8'hBB;
            @(posedge clk);
            #1 data = 8'hCC;
            @(posedge clk);
            #1 data = 8'hDD;
            @(posedge clk);
            #1 data = 8'hEE;
            @(posedge clk);
            #1 data = 8'hFF;
            @(posedge clk);

            #1 #1;
 check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Mismatch at start...");
            reset_dut();
            address = 48'h112233445566;

            @(posedge clk);
            #1 go = 1; data = 8'h00;
            @(posedge clk);
            #1 go = 0; data = 8'h22;
            @(posedge clk);
            #1 data = 8'h33;
            @(posedge clk);
            #1 data = 8'h44;
            @(posedge clk);
            #1 data = 8'h55;
            @(posedge clk);
            #1 data = 8'h66;
            @(posedge clk);

            #1 #1;
 check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Mismatch in the middle...");
            reset_dut();
            address = 48'h010203040506;

            @(posedge clk);
            #1 go = 1; data = 8'h01;
            @(posedge clk);
            #1 go = 0; data = 8'h02;
            @(posedge clk);
            #1 data = 8'hFF;
            @(posedge clk);
            #1 data = 8'h04;
            @(posedge clk);
            #1 data = 8'h05;
            @(posedge clk);
            #1 data = 8'h06;
            @(posedge clk);

            #1 #1;
 check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Mismatch at last byte...");
            reset_dut();
            address = 48'hFFFFFFFFFFFF;

            @(posedge clk);
            #1 go = 1; data = 8'hFF;
            @(posedge clk);
            #1 go = 0; data = 8'hFF;
            @(posedge clk);
            #1 data = 8'hFF;
            @(posedge clk);
            #1 data = 8'hFF;
            @(posedge clk);
            #1 data = 8'hFF;
            @(posedge clk);
            #1 data = 8'h00;
            @(posedge clk);

            #1 #1;
 check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Reset during transaction...");
            reset_dut();
            address = 48'hAABBCCDDEEFF;

            @(posedge clk);
            #1 go = 1; data = 8'hAA;
            @(posedge clk);
            #1 go = 0; data = 8'hBB;
            @(posedge clk);
            #1 reset = 1;
            @(posedge clk);
            #1 reset = 0;


            #1 #1;
 check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Consecutive matches...");
            reset_dut();


            address = 48'h123456789ABC;
            @(posedge clk);
            #1 go = 1; data = 8'h12;
            @(posedge clk);
            #1 go = 0; data = 8'h34;
            @(posedge clk);
            #1 data = 8'h56;
            @(posedge clk);
            #1 data = 8'h78;
            @(posedge clk);
            #1 data = 8'h9A;
            @(posedge clk);
            #1 data = 8'hBC;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 1'b1);


            @(posedge clk);
            address = 48'hFEDCBA987654;
            @(posedge clk);
            #1 go = 1; data = 8'hFE;
            @(posedge clk);
            #1 go = 0; data = 8'hDC;
            @(posedge clk);
            #1 data = 8'hBA;
            @(posedge clk);
            #1 data = 8'h98;
            @(posedge clk);
            #1 data = 8'h76;
            @(posedge clk);
            #1 data = 8'h54;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 1'b1);
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
        input expected_done;
        input expected_match;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_match === (expected_match ^ match ^ expected_match)) begin
                $display("PASS");
                $display("  Outputs: done=%b, match=%b",
                         done, match);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, match=%b",
                         expected_done, expected_match);
                $display("  Got:      done=%b, match=%b",
                         done, match);
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
        $dumpvars(0,address, clk, data, go, reset, done, match);
    end

endmodule
