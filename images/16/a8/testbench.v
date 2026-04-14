`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] frame_length;
    reg [15:0] payload_length;
    reg reset;
    wire frame_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .frame_length(frame_length),
        .payload_length(payload_length),
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
            frame_length = 0;
            payload_length = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Standard Valid Frame (Length: 100)", test_num);
            reset_dut();
            frame_length = 16'd100;
            payload_length = 16'd100;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Invalid Frame (Short payload: 50 vs 100)", test_num);
            reset_dut();
            frame_length = 16'd100;
            payload_length = 16'd50;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Invalid Frame (Long payload: 200 vs 150)", test_num);
            reset_dut();
            frame_length = 16'd150;
            payload_length = 16'd200;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Valid Max MTU Frame (Length: 1500)", test_num);
            reset_dut();
            frame_length = 16'd1500;
            payload_length = 16'd1500;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Zero Length Frame Check", test_num);
            reset_dut();
            frame_length = 16'd0;
            payload_length = 16'd0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Max 16-bit Length Valid Check", test_num);
            reset_dut();
            frame_length = 16'hFFFF;
            payload_length = 16'hFFFF;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Large Value Mismatch Check", test_num);
            reset_dut();
            frame_length = 16'hFFFF;
            payload_length = 16'hFFFE;
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
        $dumpvars(0,clk, frame_length, payload_length, reset, frame_valid);
    end

endmodule
