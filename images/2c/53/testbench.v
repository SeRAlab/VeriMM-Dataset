`timescale 1ns/1ps

module nvme_command_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] command_in;
    reg reset;
    reg submit_command;
    wire [3:0] command_status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nvme_command_controller dut (
        .clk(clk),
        .command_in(command_in),
        .reset(reset),
        .submit_command(submit_command),
        .command_status(command_status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            submit_command = 0;
            command_in = 4'h0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Verify Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Basic Command Submission (0x5)", test_num);
            reset_dut();
            command_in = 4'h5;
            submit_command = 1;
            @(posedge clk);
            #2;
            submit_command = 0;

            #1;


            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Max Value Command Submission (0xF)", test_num);
            reset_dut();
            command_in = 4'hF;
            submit_command = 1;
            @(posedge clk);
            #2;
            submit_command = 0;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Verify No Change without Submit signal", test_num);
            reset_dut();
            command_in = 4'hA;
            submit_command = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Sequential Command Updates (0x3 then 0x7)", test_num);
            reset_dut();


            command_in = 4'h3;
            submit_command = 1;
            @(posedge clk);
            #2;


            command_in = 4'h7;
            submit_command = 1;
            @(posedge clk);
            #2;
            submit_command = 0;


            #1;



            check_outputs(4'h7);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Reset after Command Submission", test_num);
            reset_dut();


            command_in = 4'hE;
            submit_command = 1;
            @(posedge clk);
            #2;
            submit_command = 0;


            reset = 1;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);


            #1;



            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Command Persistence", test_num);
            reset_dut();

            command_in = 4'hC;
            submit_command = 1;
            @(posedge clk);
            #2;
            submit_command = 0;
            command_in = 4'h1;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(4'hC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nvme_command_controller Testbench");
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
        input [3:0] expected_command_status;
        begin
            if (expected_command_status === (expected_command_status ^ command_status ^ expected_command_status)) begin
                $display("PASS");
                $display("  Outputs: command_status=%h",
                         command_status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: command_status=%h",
                         expected_command_status);
                $display("  Got:      command_status=%h",
                         command_status);
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
        $dumpvars(0,clk, command_in, reset, submit_command, command_status);
    end

endmodule
