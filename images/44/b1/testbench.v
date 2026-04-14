`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [255:0] cam_data_in;
    reg cam_enable;
    reg clk;
    wire [7:0] cam_addr_out;
    wire cam_hit_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cam_data_in(cam_data_in),
        .cam_enable(cam_enable),
        .clk(clk),
        .cam_addr_out(cam_addr_out),
        .cam_hit_out(cam_hit_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            cam_enable = 0;
            cam_data_in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic hit at address 0", test_num);

            cam_enable = 1;
            cam_data_in = 256'b0;
            cam_data_in[0] = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic hit at address 255", test_num);

            cam_enable = 1;
            cam_data_in = 256'b0;
            cam_data_in[255] = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd255, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Priority check (bits 10, 20, 30 set)", test_num);

            cam_enable = 1;
            cam_data_in = 256'b0;
            cam_data_in[10] = 1;
            cam_data_in[20] = 1;
            cam_data_in[30] = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd10, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: No bits set (No Hit)", test_num);

            cam_enable = 1;
            cam_data_in = 256'b0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Enable low with valid data", test_num);

            cam_enable = 0;
            cam_data_in = 256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Hit at address 128", test_num);

            cam_enable = 1;
            cam_data_in = 256'b0;
            cam_data_in[128] = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd128, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential update check", test_num);


            cam_enable = 1;
            cam_data_in = 256'b0;
            cam_data_in[50] = 1;
            @(posedge clk);
            #2;


            cam_data_in = 256'b0;
            cam_data_in[75] = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd75, 1'b1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Toggle enable while data present", test_num);

            cam_enable = 1;
            cam_data_in = 256'b0;
            cam_data_in[15] = 1;
            @(posedge clk);
            #2;

            cam_enable = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd0, 1'b0);
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
        input [7:0] expected_cam_addr_out;
        input expected_cam_hit_out;
        begin
            if (expected_cam_addr_out === (expected_cam_addr_out ^ cam_addr_out ^ expected_cam_addr_out) &&
                expected_cam_hit_out === (expected_cam_hit_out ^ cam_hit_out ^ expected_cam_hit_out)) begin
                $display("PASS");
                $display("  Outputs: cam_addr_out=%h, cam_hit_out=%b",
                         cam_addr_out, cam_hit_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cam_addr_out=%h, cam_hit_out=%b",
                         expected_cam_addr_out, expected_cam_hit_out);
                $display("  Got:      cam_addr_out=%h, cam_hit_out=%b",
                         cam_addr_out, cam_hit_out);
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
        $dumpvars(0,cam_data_in, cam_enable, clk, cam_addr_out, cam_hit_out);
    end

endmodule
