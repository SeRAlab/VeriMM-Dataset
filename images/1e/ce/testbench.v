`timescale 1ns/1ps

module deserializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg rst;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deserializer dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        data_in = 4'b0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nRunning testcase%03d: All Zeros", test_num);
        reset_dut();
        repeat(8) begin
            data_in = 4'h0;
            @(posedge clk);
        end
        #1 #1;
 check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nRunning testcase%03d: All Ones", test_num);
        reset_dut();
        repeat(8) begin
            data_in = 4'hF;
            @(posedge clk);
        end
        #1 #1;
 check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nRunning testcase%03d: Sequential Pattern", test_num);
        reset_dut();
        data_in = 4'h1; @(posedge clk);
        data_in = 4'h2; @(posedge clk);
        data_in = 4'h3; @(posedge clk);
        data_in = 4'h4; @(posedge clk);
        data_in = 4'h5; @(posedge clk);
        data_in = 4'h6; @(posedge clk);
        data_in = 4'h7; @(posedge clk);
        data_in = 4'h8; @(posedge clk);
        #1 #1;
 check_outputs(32'h12345678);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nRunning testcase%03d: Alternating Pattern", test_num);
        reset_dut();
        repeat(4) begin
            data_in = 4'hA; @(posedge clk);
            data_in = 4'h5; @(posedge clk);
        end
        #1 #1;
 check_outputs(32'hA5A5A5A5);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nRunning testcase%03d: DEADBEEF", test_num);
        reset_dut();
        data_in = 4'hD; @(posedge clk);
        data_in = 4'hE; @(posedge clk);
        data_in = 4'hA; @(posedge clk);
        data_in = 4'hD; @(posedge clk);
        data_in = 4'hB; @(posedge clk);
        data_in = 4'hE; @(posedge clk);
        data_in = 4'hE; @(posedge clk);
        data_in = 4'hF; @(posedge clk);
        #1 #1;
 check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nRunning testcase%03d: Reset Mid-stream", test_num);
        reset_dut();

        repeat(4) begin
            data_in = 4'hF; @(posedge clk);
        end

        rst = 1; @(posedge clk);
        rst = 0; data_in = 4'h1; @(posedge clk);

        data_in = 4'h2; @(posedge clk);
        data_in = 4'h3; @(posedge clk);
        data_in = 4'h4; @(posedge clk);
        data_in = 4'h5; @(posedge clk);
        data_in = 4'h6; @(posedge clk);
        data_in = 4'h7; @(posedge clk);
        data_in = 4'h8; @(posedge clk);
        #1 #1;
 check_outputs(32'h12345678);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deserializer Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [31:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, rst, data_out);
    end

endmodule
