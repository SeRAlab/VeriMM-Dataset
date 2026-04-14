`timescale 1ns/1ps

module nvme_command_queue_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] command_in;
    reg read;
    reg reset;
    reg write;
    wire [3:0] command_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nvme_command_queue dut (
        .clk(clk),
        .command_in(command_in),
        .read(read),
        .reset(reset),
        .write(write),
        .command_out(command_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            write = 0;
            read = 0;
            command_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Enqueue", test_num);
            reset_dut();

            command_in = 4'hA;
            write = 1;
            @(posedge clk);
            #1 write = 0;
            @(posedge clk);

            #1;


            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Enqueue two, Dequeue one", test_num);
            reset_dut();


            command_in = 4'h5;
            write = 1;
            @(posedge clk);
            #1;

            command_in = 4'h3;
            write = 1;
            @(posedge clk);
            #1;
            write = 0;


            read = 1;
            @(posedge clk);
            #1;
            read = 0;
            @(posedge clk);


            #1;



            check_outputs(4'h3);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase %0d: Fill queue (8 items)", test_num);
            reset_dut();


            for (i = 1; i <= 8; i = i + 1) begin
                command_in = i;
                write = 1;
                @(posedge clk);
                #1;
            end
            write = 0;


            read = 1;
            repeat (7) begin
                @(posedge clk);
                #1;
            end
            read = 0;
            @(posedge clk);

            #1;


            check_outputs(4'h8);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %0d: Wrap-around logic", test_num);
            reset_dut();


            write = 1;
            for (i = 1; i <= 5; i = i + 1) begin
                command_in = i;
                @(posedge clk);
                #1;
            end
            write = 0;


            read = 1;
            repeat (5) begin
                @(posedge clk);
                #1;
            end
            read = 0;


            command_in = 4'hF;
            write = 1;
            @(posedge clk);
            #1;
            write = 0;
            @(posedge clk);

            #1;


            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Simultaneous Read and Write", test_num);
            reset_dut();


            command_in = 4'h7;
            write = 1;
            @(posedge clk);
            #1;


            command_in = 4'h9;
            write = 1;
            read = 1;
            @(posedge clk);
            #1;
            write = 0;
            read = 0;
            @(posedge clk);

            #1;


            check_outputs(4'h9);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nvme_command_queue Testbench");
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
        input [3:0] expected_command_out;
        begin
            if (expected_command_out === (expected_command_out ^ command_out ^ expected_command_out)) begin
                $display("PASS");
                $display("  Outputs: command_out=%h",
                         command_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: command_out=%h",
                         expected_command_out);
                $display("  Got:      command_out=%h",
                         command_out);
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
        $dumpvars(0,clk, command_in, read, reset, write, command_out);
    end

endmodule
