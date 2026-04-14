`timescale 1ns/1ps

module pipeline_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] instr;
    reg reset;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_processor dut (
        .clk(clk),
        .instr(instr),
        .reset(reset),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            instr = 32'h0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task drive_instr;

        input [31:0] next_instr;
        begin
            @(negedge clk);
            instr = next_instr;
            @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Basic Addition (ADD R10, R5 -> R15)", test_num);
            reset_dut();


            drive_instr({6'h01, 5'd10, 5'd5, 5'd15, 11'h0});


            repeat(4) drive_instr(32'h0);


            #1;



            check_outputs(32'd15);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Basic Subtraction (SUB R20, R8 -> R12)", test_num);
            reset_dut();


            drive_instr({6'h02, 5'd20, 5'd8, 5'd12, 11'h0});


            repeat(4) drive_instr(32'h0);

            #1;


            check_outputs(32'd12);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Pipeline Flow (ADD followed by SUB)", test_num);
            reset_dut();


            drive_instr({6'h01, 5'd1, 5'd2, 5'd3, 11'h0});

            drive_instr({6'h02, 5'd10, 5'd4, 5'd6, 11'h0});


            repeat(4) drive_instr(32'h0);


            #1;



            check_outputs(32'd6);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Subtraction resulting in Zero", test_num);
            reset_dut();

            drive_instr({6'h02, 5'd5, 5'd5, 5'd10, 11'h0});
            repeat(4) drive_instr(32'h0);

            #1;


            check_outputs(32'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Large Register Index Addition", test_num);
            reset_dut();


            drive_instr({6'h01, 5'd30, 5'd31, 5'd1, 11'h0});
            repeat(4) drive_instr(32'h0);

            #1;


            check_outputs(32'd61);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline_processor Testbench");
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
        input [31:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,clk, instr, reset, result);
    end

endmodule
