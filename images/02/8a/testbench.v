`timescale 1ns/1ps

module nvme_queue_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dequeue;
    reg enqueue;
    reg [2:0] q_id;
    reg reset;
    wire [3:0] command_count;
    wire [7:0] queue_status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nvme_queue_controller dut (
        .clk(clk),
        .dequeue(dequeue),
        .enqueue(enqueue),
        .q_id(q_id),
        .reset(reset),
        .command_count(command_count),
        .queue_status(queue_status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            reset = 1;
            enqueue = 0;
            dequeue = 0;
            q_id = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Behavior", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Enqueue", test_num);
            reset_dut();

            q_id = 3'd2;
            enqueue = 1;
            @(posedge clk);
            enqueue = 0;
            @(posedge clk);


            #1;



            check_outputs(4'h1, 8'h04);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enqueue/Dequeue sequence", test_num);
            reset_dut();

            q_id = 3'd5;

            repeat(3) begin
                enqueue = 1; @(posedge clk);
            end
            enqueue = 0;


            dequeue = 1; @(posedge clk);
            dequeue = 0;
            @(posedge clk);


            #1;



            check_outputs(4'h2, 8'h20);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Queues Active", test_num);
            reset_dut();


            q_id = 3'd0; enqueue = 1; @(posedge clk); enqueue = 0;


            q_id = 3'd7; enqueue = 1; @(posedge clk); enqueue = 0;

            @(posedge clk);

            #1;


            check_outputs(4'h1, 8'h81);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max Command Count", test_num);
            reset_dut();

            q_id = 3'd1;
            enqueue = 1;
            repeat(15) @(posedge clk);
            enqueue = 0;
            @(posedge clk);


            #1;



            check_outputs(4'hF, 8'h02);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Emptying Queue Status", test_num);
            reset_dut();

            q_id = 3'd4;

            enqueue = 1; @(posedge clk); enqueue = 0;

            dequeue = 1; @(posedge clk); dequeue = 0;
            @(posedge clk);


            #1;



            check_outputs(4'h0, 8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Context Switching", test_num);
            reset_dut();


            q_id = 3'd2; enqueue = 1; repeat(2) @(posedge clk); enqueue = 0;


            q_id = 3'd6; enqueue = 1; repeat(5) @(posedge clk); enqueue = 0;


            q_id = 3'd2;
            @(posedge clk);


            #1;



            check_outputs(4'h2, 8'h44);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nvme_queue_controller Testbench");
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
        input [3:0] expected_command_count;
        input [7:0] expected_queue_status;
        begin
            if (expected_command_count === (expected_command_count ^ command_count ^ expected_command_count) &&
                expected_queue_status === (expected_queue_status ^ queue_status ^ expected_queue_status)) begin
                $display("PASS");
                $display("  Outputs: command_count=%h, queue_status=%h",
                         command_count, queue_status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: command_count=%h, queue_status=%h",
                         expected_command_count, expected_queue_status);
                $display("  Got:      command_count=%h, queue_status=%h",
                         command_count, queue_status);
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
        $dumpvars(0,clk, dequeue, enqueue, q_id, reset, command_count, queue_status);
    end

endmodule
