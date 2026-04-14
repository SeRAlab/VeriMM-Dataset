`timescale 1ns/1ps

module tcp_segmenter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg data_valid;
    wire [31:0] packet_out;
    wire packet_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segmenter dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .packet_out(packet_out),
        .packet_valid(packet_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_in <= 32'h0;
            data_valid <= 1'b0;
            repeat (5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Basic Single Word", test_num);
            reset_dut();

            @(posedge clk);
            data_in <= 32'hABCDEF01;
            data_valid <= 1'b1;
            @(posedge clk);
            data_valid <= 1'b0;
            data_in <= 32'h0;


            repeat (2) @(posedge clk);

            #1;


            check_outputs(32'hABCDEF01, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Data with Invalid Signal", test_num);
            reset_dut();

            @(posedge clk);
            data_in <= 32'hFFFFFFFF;
            data_valid <= 1'b0;
            @(posedge clk);

            repeat (2) @(posedge clk);



            #1;




            check_outputs(packet_out, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Streaming Data", test_num);
            reset_dut();

            @(posedge clk);
            data_in <= 32'h11112222;
            data_valid <= 1'b1;
            @(posedge clk);
            data_in <= 32'h33334444;
            data_valid <= 1'b1;
            @(posedge clk);
            data_valid <= 1'b0;

            repeat (2) @(posedge clk);


            #1;



            check_outputs(32'h33334444, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Intermittent Data", test_num);
            reset_dut();

            @(posedge clk);
            data_in <= 32'hCAFEBABE;
            data_valid <= 1'b1;
            @(posedge clk);
            data_valid <= 1'b0;
            repeat (3) @(posedge clk);
            data_in <= 32'hDEADBEEF;
            data_valid <= 1'b1;
            @(posedge clk);
            data_valid <= 1'b0;

            repeat (2) @(posedge clk);

            #1;


            check_outputs(32'hDEADBEEF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Zero Data Word", test_num);
            reset_dut();

            @(posedge clk);
            data_in <= 32'h00000000;
            data_valid <= 1'b1;
            @(posedge clk);
            data_valid <= 1'b0;

            repeat (2) @(posedge clk);

            #1;


            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("tcp_segmenter Testbench");
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
        input [31:0] expected_packet_out;
        input expected_packet_valid;
        begin
            if (expected_packet_out === (expected_packet_out ^ packet_out ^ expected_packet_out) &&
                expected_packet_valid === (expected_packet_valid ^ packet_valid ^ expected_packet_valid)) begin
                $display("PASS");
                $display("  Outputs: packet_out=%h, packet_valid=%b",
                         packet_out, packet_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: packet_out=%h, packet_valid=%b",
                         expected_packet_out, expected_packet_valid);
                $display("  Got:      packet_out=%h, packet_valid=%b",
                         packet_out, packet_valid);
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
        $dumpvars(0,clk, data_in, data_valid, packet_out, packet_valid);
    end

endmodule
