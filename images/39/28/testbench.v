`timescale 1ns/1ps

module ARQReceiver_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] checksum;
    reg clk;
    reg [7:0] data;
    reg enable;
    wire ack;
    wire nack;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQReceiver dut (
        .checksum(checksum),
        .clk(clk),
        .data(data),
        .enable(enable),
        .ack(ack),
        .nack(nack),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            data = 8'h00;
            checksum = 8'h00;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Valid data match", test_num);
            reset_dut();

            @(posedge clk);
            data = 8'hA5;
            checksum = 8'hA5;
            enable = 1'b1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checksum mismatch", test_num);
            reset_dut();

            @(posedge clk);
            data = 8'hA5;
            checksum = 8'h5A;
            enable = 1'b1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: System disabled", test_num);
            reset_dut();

            @(posedge clk);
            data = 8'hFF;
            checksum = 8'hFF;
            enable = 1'b0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zeros match", test_num);
            reset_dut();

            @(posedge clk);
            data = 8'h00;
            checksum = 8'h00;
            enable = 1'b1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All ones match", test_num);
            reset_dut();

            @(posedge clk);
            data = 8'hFF;
            checksum = 8'hFF;
            enable = 1'b1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ARQReceiver Testbench");
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
        input expected_ack;
        input expected_nack;
        input expected_valid;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_nack === (expected_nack ^ nack ^ expected_nack) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, nack=%b, valid=%b",
                         ack, nack, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, nack=%b, valid=%b",
                         expected_ack, expected_nack, expected_valid);
                $display("  Got:      ack=%b, nack=%b, valid=%b",
                         ack, nack, valid);
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
        $dumpvars(0,checksum, clk, data, enable, ack, nack, valid);
    end

endmodule
