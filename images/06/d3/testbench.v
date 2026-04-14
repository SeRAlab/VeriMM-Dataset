`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [47:0] dest_address;
    reg [15:0] frame_length;
    reg reset;
    wire frame_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .dest_address(dest_address),
        .frame_length(frame_length),
        .reset(reset),
        .frame_valid(frame_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            dest_address = 48'b0;
            frame_length = 16'b0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Valid address, Min Length (64)", test_num);
            reset_dut();
            dest_address = 48'h112233445566;
            frame_length = 16'd64;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Valid address, Max Length (1518)", test_num);
            reset_dut();
            dest_address = 48'h112233445566;
            frame_length = 16'd1518;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Valid address, Typical Length (500)", test_num);
            reset_dut();
            dest_address = 48'h112233445566;
            frame_length = 16'd500;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Invalid address, Valid Length", test_num);
            reset_dut();
            dest_address = 48'hAABBCCDDEEFF;
            frame_length = 16'd128;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Valid address, Length too small (63)", test_num);
            reset_dut();
            dest_address = 48'h112233445566;
            frame_length = 16'd63;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Valid address, Length too large (1519)", test_num);
            reset_dut();
            dest_address = 48'h112233445566;
            frame_length = 16'd1519;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Valid address, Length 0", test_num);
            reset_dut();
            dest_address = 48'h112233445566;
            frame_length = 16'd0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initial state check after reset", test_num);
            reset_dut();

            @(posedge clk);
            #1 #1;
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
        input expected_frame_valid;
        begin
            if (expected_frame_valid === (expected_frame_valid ^ frame_valid ^ expected_frame_valid)) begin
                $display("PASS");
                $display("  Outputs: frame_valid=%b",
                         frame_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frame_valid=%b",
                         expected_frame_valid);
                $display("  Got:      frame_valid=%b",
                         frame_valid);
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
        $dumpvars(0,clk, dest_address, frame_length, reset, frame_valid);
    end

endmodule
