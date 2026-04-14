`timescale 1ns/1ps

module deserializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg serialized_data;
    wire data_ready;
    wire [7:0] deserialized_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deserializer dut (
        .clk(clk),
        .reset(reset),
        .serialized_data(serialized_data),
        .data_ready(data_ready),
        .deserialized_data(deserialized_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            serialized_data = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task send_bits;

        input [7:0] data_in;
        integer i;
        begin
            for (i = 7; i >= 0; i = i - 1) begin
                serialized_data = data_in[i];
                @(posedge clk);
            end
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sending 8'hAA (10101010)", test_num);
            reset_dut();
            send_bits(8'hAA);
            #2;
            #1;

            check_outputs(1'b1, 8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sending 8'h55 (01010101)", test_num);
            reset_dut();
            send_bits(8'h55);
            #2;
            #1;

            check_outputs(1'b1, 8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sending 8'hFF (11111111)", test_num);
            reset_dut();
            send_bits(8'hFF);
            #2;
            #1;

            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sending 8'h00 (00000000)", test_num);
            reset_dut();
            send_bits(8'h00);
            #2;
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sending 8'hF0 (11110000)", test_num);
            reset_dut();
            send_bits(8'hF0);
            #2;
            #1;

            check_outputs(1'b1, 8'hF0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sending 8'hC3 (11000011)", test_num);
            reset_dut();
            send_bits(8'hC3);
            #2;
            #1;

            check_outputs(1'b1, 8'hC3);
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
        input expected_data_ready;
        input [7:0] expected_deserialized_data;
        begin
            if (expected_data_ready === (expected_data_ready ^ data_ready ^ expected_data_ready) &&
                expected_deserialized_data === (expected_deserialized_data ^ deserialized_data ^ expected_deserialized_data)) begin
                $display("PASS");
                $display("  Outputs: data_ready=%b, deserialized_data=%h",
                         data_ready, deserialized_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_ready=%b, deserialized_data=%h",
                         expected_data_ready, expected_deserialized_data);
                $display("  Got:      data_ready=%b, deserialized_data=%h",
                         data_ready, deserialized_data);
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
        $dumpvars(0,clk, reset, serialized_data, data_ready, deserialized_data);
    end

endmodule
