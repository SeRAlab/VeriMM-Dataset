`timescale 1ns/1ps

module page_table_manager_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] page_number;
    reg valid_bit;
    wire [3:0] frame_number;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    page_table_manager dut (
        .clk(clk),
        .page_number(page_number),
        .valid_bit(valid_bit),
        .frame_number(frame_number),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            page_number <= 0;
            valid_bit <= 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Requesting Valid Page 5", test_num);
            reset_dut();
            page_number <= 4'd5;
            valid_bit <= 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Requesting Invalid Page 2", test_num);
            reset_dut();
            page_number <= 4'd2;
            valid_bit <= 1'b0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(frame_number, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Requesting Valid Page 15", test_num);
            reset_dut();
            page_number <= 4'd15;
            valid_bit <= 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd15, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Requesting Valid Page 0", test_num);
            reset_dut();
            page_number <= 4'd0;
            valid_bit <= 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Transition from Valid to Invalid (Page 8)", test_num);
            reset_dut();

            page_number <= 4'd8;
            valid_bit <= 1'b1;
            @(posedge clk);
            #2;

            page_number <= 4'd8;
            valid_bit <= 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(frame_number, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("page_table_manager Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [3:0] expected_frame_number;
        input expected_valid_out;
        begin
            if (expected_frame_number === (expected_frame_number ^ frame_number ^ expected_frame_number) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: frame_number=%h, valid_out=%b",
                         frame_number, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frame_number=%h, valid_out=%b",
                         expected_frame_number, expected_valid_out);
                $display("  Got:      frame_number=%h, valid_out=%b",
                         frame_number, valid_out);
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
        $dumpvars(0,clk, page_number, valid_bit, frame_number, valid_out);
    end

endmodule
