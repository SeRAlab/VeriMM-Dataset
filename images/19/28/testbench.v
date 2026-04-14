`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] frame_data;
    reg frame_valid;
    reg reset;
    wire [127:0] frame_buffer;
    wire frame_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .frame_data(frame_data),
        .frame_valid(frame_valid),
        .reset(reset),
        .frame_buffer(frame_buffer),
        .frame_ready(frame_ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            frame_data = 0;
            frame_valid = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Single valid frame reception", test_num);
            reset_dut();

            frame_data = 128'hABCDEF0123456789ABCDEF0123456789;
            frame_valid = 1;
            @(posedge clk);
            #1;
            frame_valid = 0;

            #1;


            check_outputs(128'hABCDEF0123456789ABCDEF0123456789, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Ignore data when frame_valid is low", test_num);
            reset_dut();

            frame_data = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            frame_valid = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(128'h0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Successive frame reception (buffer update)", test_num);
            reset_dut();


            frame_data = 128'h11111111111111111111111111111111;
            frame_valid = 1;
            @(posedge clk);


            frame_data = 128'h22222222222222222222222222222222;
            frame_valid = 1;
            @(posedge clk);
            #1;
            frame_valid = 0;


            #1;



            check_outputs(128'h22222222222222222222222222222222, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Reset during active state", test_num);
            reset_dut();


            frame_data = 128'h5555AAAA5555AAAA5555AAAA5555AAAA;
            frame_valid = 1;
            @(posedge clk);
            #1;


            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;

            #1;


            check_outputs(128'h0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Intermittent valid signals", test_num);
            reset_dut();


            frame_data = 128'hDADA_DADA_DADA_DADA_DADA_DADA_DADA_DADA;
            frame_valid = 1;
            @(posedge clk);


            frame_valid = 0;
            frame_data = 128'h0;
            repeat(3) @(posedge clk);


            #1;



            check_outputs(128'hDADA_DADA_DADA_DADA_DADA_DADA_DADA_DADA, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ethernet_mac_controller Testbench");
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
        input [127:0] expected_frame_buffer;
        input expected_frame_ready;
        begin
            if (expected_frame_buffer === (expected_frame_buffer ^ frame_buffer ^ expected_frame_buffer) &&
                expected_frame_ready === (expected_frame_ready ^ frame_ready ^ expected_frame_ready)) begin
                $display("PASS");
                $display("  Outputs: frame_buffer=%h, frame_ready=%b",
                         frame_buffer, frame_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frame_buffer=%h, frame_ready=%b",
                         expected_frame_buffer, expected_frame_ready);
                $display("  Got:      frame_buffer=%h, frame_ready=%b",
                         frame_buffer, frame_ready);
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
        $dumpvars(0,clk, frame_data, frame_valid, reset, frame_buffer, frame_ready);
    end

endmodule
