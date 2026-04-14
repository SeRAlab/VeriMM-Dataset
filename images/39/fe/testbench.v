`timescale 1ns/1ps

module pcie_endpoint_controller_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg req_read;
    reg req_write;
    reg reset;
    wire processing_read;
    wire processing_write;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_endpoint_controller dut (
        .ack(ack),
        .clk(clk),
        .req_read(req_read),
        .req_write(req_write),
        .reset(reset),
        .processing_read(processing_read),
        .processing_write(processing_write),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ack = 0;
            req_read = 0;
            req_write = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset State Check");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(0, 0, IDLE);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Read Request Transition");
            test_num = 2;
            reset_dut();
            req_read = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1, 0, READ);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Write Request Transition");
            test_num = 3;
            reset_dut();
            req_write = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(0, 1, WRITE);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Read Completion with Ack");
            test_num = 4;
            reset_dut();
            req_read = 1;
            @(posedge clk);
            #2;
            req_read = 0;
            ack = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(0, 0, IDLE);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Write Completion with Ack");
            test_num = 5;
            reset_dut();
            req_write = 1;
            @(posedge clk);
            #2;
            req_write = 0;
            ack = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(0, 0, IDLE);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Simultaneous Read/Write Requests");
            test_num = 6;
            reset_dut();
            req_read = 1;
            req_write = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(0, 0, ERROR);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Persistence in READ State");
            test_num = 7;
            reset_dut();
            req_read = 1;
            @(posedge clk);
            #2;
            req_read = 0;
            repeat(3) @(posedge clk);
            #2;

            #1;


            check_outputs(1, 0, READ);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Recovery from ERROR via Reset");
            test_num = 8;
            reset_dut();
            req_read = 1;
            req_write = 1;
            @(posedge clk);
            #2;
            reset = 1;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(0, 0, IDLE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_endpoint_controller Testbench");
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
        input expected_processing_read;
        input expected_processing_write;
        input [1:0] expected_state;
        begin
            if (expected_processing_read === (expected_processing_read ^ processing_read ^ expected_processing_read) &&
                expected_processing_write === (expected_processing_write ^ processing_write ^ expected_processing_write) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: processing_read=%b, processing_write=%b, state=%h",
                         processing_read, processing_write, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: processing_read=%b, processing_write=%b, state=%h",
                         expected_processing_read, expected_processing_write, expected_state);
                $display("  Got:      processing_read=%b, processing_write=%b, state=%h",
                         processing_read, processing_write, state);
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
        $dumpvars(0,ack, clk, req_read, req_write, reset, processing_read, processing_write, state);
    end

endmodule
