`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] frame_size;
    reg frame_valid;
    reg rst;
    wire valid_frame_received;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .frame_size(frame_size),
        .frame_valid(frame_valid),
        .rst(rst),
        .valid_frame_received(valid_frame_received)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            frame_size = 0;
            frame_valid = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Minimum valid frame size (64 bytes)", test_num);
            reset_dut();

            frame_size = 16'd64;
            frame_valid = 1'b1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Maximum valid frame size (1518 bytes)", test_num);
            reset_dut();

            frame_size = 16'd1518;
            frame_valid = 1'b1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Below minimum frame size (63 bytes)", test_num);
            reset_dut();

            frame_size = 16'd63;
            frame_valid = 1'b1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Above maximum frame size (1519 bytes)", test_num);
            reset_dut();

            frame_size = 16'd1519;
            frame_valid = 1'b1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Valid size but frame_valid is low", test_num);
            reset_dut();

            frame_size = 16'd500;
            frame_valid = 1'b0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Random valid size (1000 bytes)", test_num);
            reset_dut();

            frame_size = 16'd1000;
            frame_valid = 1'b1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest Case %0d: Small invalid size (10 bytes)", test_num);
            reset_dut();

            frame_size = 16'd10;
            frame_valid = 1'b1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTest Case %0d: Large invalid size (9000 bytes - Jumbo frame)", test_num);
            reset_dut();

            frame_size = 16'd9000;
            frame_valid = 1'b1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
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
        input expected_valid_frame_received;
        begin
            if (expected_valid_frame_received === (expected_valid_frame_received ^ valid_frame_received ^ expected_valid_frame_received)) begin
                $display("PASS");
                $display("  Outputs: valid_frame_received=%b",
                         valid_frame_received);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: valid_frame_received=%b",
                         expected_valid_frame_received);
                $display("  Got:      valid_frame_received=%b",
                         valid_frame_received);
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
        $dumpvars(0,clk, frame_size, frame_valid, rst, valid_frame_received);
    end

endmodule
