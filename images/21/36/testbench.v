`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] req;
    reg rst;
    reg start;
    wire [3:0] ack;
    wire [1:0] bus;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .req(req),
        .rst(rst),
        .start(start),
        .ack(ack),
        .bus(bus)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            req = 4'b0000;
            start = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Single channel request - Channel 0", test_num);

            start = 1;
            req = 4'b0001;


            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(4'b0001, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Single channel request - Channel 3", test_num);

            start = 1;
            req = 4'b1000;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(4'b1000, 2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Priority Arbitration (Ch1 vs Ch2)", test_num);

            start = 1;
            req = 4'b0110;

            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(4'b0010, 2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Start signal logic (Start=0)", test_num);

            start = 0;
            req = 4'b1111;

            repeat(3) @(posedge clk);
            #1;


            #1;



            check_outputs(4'b0000, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Bus hold duration check", test_num);

            start = 1;
            req = 4'b0100;

            @(posedge clk);
            wait(ack[2] == 1);


            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0100, 2'b10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
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
        input [3:0] expected_ack;
        input [1:0] expected_bus;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_bus === (expected_bus ^ bus ^ expected_bus)) begin
                $display("PASS");
                $display("  Outputs: ack=%h, bus=%h",
                         ack, bus);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%h, bus=%h",
                         expected_ack, expected_bus);
                $display("  Got:      ack=%h, bus=%h",
                         ack, bus);
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
        $dumpvars(0,clk, req, rst, start, ack, bus);
    end

endmodule
