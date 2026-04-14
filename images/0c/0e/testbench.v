`timescale 1ns/1ps

module nvme_command_scheduler_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] cmd_in;
    reg cmd_valid;
    reg rst;
    wire [4:0] cmd_out;
    wire cmd_processing;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nvme_command_scheduler dut (
        .clk(clk),
        .cmd_in(cmd_in),
        .cmd_valid(cmd_valid),
        .rst(rst),
        .cmd_out(cmd_out),
        .cmd_processing(cmd_processing)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            cmd_in = 5'b0;
            cmd_valid = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verification of Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(5'b00000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Command Processing", test_num);
            reset_dut();

            @(posedge clk);
            cmd_in = 5'h0A;
            cmd_valid = 1;
            @(posedge clk);
            cmd_valid = 0;
            cmd_in = 5'h00;


            repeat(2) @(posedge clk);

            #1;


            check_outputs(5'h0A, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Sequential Command Handling", test_num);
            reset_dut();


            @(posedge clk);
            cmd_in = 5'h01;
            cmd_valid = 1;
            @(posedge clk);


            cmd_in = 5'h02;
            cmd_valid = 1;
            @(posedge clk);
            cmd_valid = 0;


            repeat(2) @(posedge clk);


            #1;



            check_outputs(5'h01, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Rapid Command Input and Flag Check", test_num);
            reset_dut();

            @(posedge clk);
            cmd_in = 5'h1F;
            cmd_valid = 1;
            @(posedge clk);
            cmd_valid = 0;


            #1;
            if (cmd_processing == 1'b1 || cmd_out == 5'h1F) begin

                #1;


                check_outputs(5'h1F, 1'b1);
            end else begin

                @(posedge clk);
                #1;

                check_outputs(5'h1F, 1'b1);
            end
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Processing Persistence", test_num);
            reset_dut();

            @(posedge clk);
            cmd_in = 5'h05;
            cmd_valid = 1;
            @(posedge clk);
            cmd_valid = 0;



            repeat(4) @(posedge clk);

            #1;


            check_outputs(5'h05, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nvme_command_scheduler Testbench");
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
        input [4:0] expected_cmd_out;
        input expected_cmd_processing;
        begin
            if (expected_cmd_out === (expected_cmd_out ^ cmd_out ^ expected_cmd_out) &&
                expected_cmd_processing === (expected_cmd_processing ^ cmd_processing ^ expected_cmd_processing)) begin
                $display("PASS");
                $display("  Outputs: cmd_out=%h, cmd_processing=%b",
                         cmd_out, cmd_processing);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cmd_out=%h, cmd_processing=%b",
                         expected_cmd_out, expected_cmd_processing);
                $display("  Got:      cmd_out=%h, cmd_processing=%b",
                         cmd_out, cmd_processing);
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
        $dumpvars(0,clk, cmd_in, cmd_valid, rst, cmd_out, cmd_processing);
    end

endmodule
