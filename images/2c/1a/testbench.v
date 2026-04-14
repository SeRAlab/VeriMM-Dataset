`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] data_in;
    reg rst;
    reg valid;
    wire [31:0] fcs_out;
    wire frame_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .valid(valid),
        .fcs_out(fcs_out),
        .frame_valid(frame_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            valid = 0;
            data_in = 64'h0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            data_in = 64'hACE0BACE_ACE0BACE;
            valid = 1;
            @(posedge clk);
            #2;
            $display("Test %0d: Data halves match (Expected valid)", test_num);
            #1;

            check_outputs(32'h0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            data_in = 64'h12345678_00000000;
            valid = 1;
            @(posedge clk);
            #2;
            $display("Test %0d: Data halves do not match (Expected invalid)", test_num);
            #1;

            check_outputs(32'h12345678, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            data_in = 64'h00000000_00000000;
            valid = 1;
            @(posedge clk);
            #2;
            $display("Test %0d: All zeros data", test_num);
            #1;

            check_outputs(32'h0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            data_in = 64'hFFFFFFFF_FFFFFFFF;
            valid = 1;
            @(posedge clk);
            #2;
            $display("Test %0d: All ones data", test_num);
            #1;

            check_outputs(32'h0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            data_in = 64'hAAAAAAAA_55555555;
            valid = 1;
            @(posedge clk);
            #2;
            $display("Test %0d: Bitwise inverse data halves", test_num);
            #1;

            check_outputs(32'hFFFFFFFF, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();


            data_in = 64'hAAAA5555_AAAA5555;
            valid = 1;
            @(posedge clk);
            #1;


            data_in = 64'hFFFFFFFF_00000000;
            valid = 0;
            @(posedge clk);
            #2;

            $display("Test %0d: Valid signal low (Output should remain from previous cycle)", test_num);

            #1;


            check_outputs(32'h0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            data_in = 64'h00000001_00000000;
            valid = 1;
            @(posedge clk);
            #2;
            $display("Test %0d: Single bit difference", test_num);
            #1;

            check_outputs(32'h00000001, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ethernet_mac_controller Testbench");
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
        input [31:0] expected_fcs_out;
        input expected_frame_valid;
        begin
            if (expected_fcs_out === (expected_fcs_out ^ fcs_out ^ expected_fcs_out) &&
                expected_frame_valid === (expected_frame_valid ^ frame_valid ^ expected_frame_valid)) begin
                $display("PASS");
                $display("  Outputs: fcs_out=%h, frame_valid=%b",
                         fcs_out, frame_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fcs_out=%h, frame_valid=%b",
                         expected_fcs_out, expected_frame_valid);
                $display("  Got:      fcs_out=%h, frame_valid=%b",
                         fcs_out, frame_valid);
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
        $dumpvars(0,clk, data_in, rst, valid, fcs_out, frame_valid);
    end

endmodule
