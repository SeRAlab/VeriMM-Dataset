`timescale 1ns/1ps

module deserializer_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] data_in;
    reg reset;
    wire [31:0] data_out1;
    wire [31:0] data_out2;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deserializer_32bit dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .data_out1(data_out1),
        .data_out2(data_out2),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 64'b0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Zeros", test_num);
            reset_dut();

            data_in = 64'h00000000_00000000;


            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00000000, 32'h00000000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Ones", test_num);
            reset_dut();

            data_in = 64'hFFFFFFFF_FFFFFFFF;

            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hFFFFFFFF, 32'hFFFFFFFF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mixed Pattern (Lower and Upper distinct)", test_num);
            reset_dut();


            data_in = 64'hDEADBEEF_CAFEBABE;

            @(posedge clk);
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'hCAFEBABE, 32'hDEADBEEF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating Bits", test_num);
            reset_dut();

            data_in = 64'hAAAAAAAAAAAAAAAA_5555555555555555;

            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h55555555, 32'hAAAAAAAA, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sequential Counter", test_num);
            reset_dut();

            data_in = 64'h12345678_9ABCDEF0;

            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h9ABCDEF0, 32'h12345678, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Impact", test_num);
            reset_dut();

            data_in = 64'hFFFFFFFF_00000000;
            @(posedge clk);

            reset = 1;
            @(posedge clk);
            reset = 0;
            #1;


            #1;



            check_outputs(32'h00000000, 32'h00000000, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deserializer_32bit Testbench");
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
        input [31:0] expected_data_out1;
        input [31:0] expected_data_out2;
        input expected_valid;
        begin
            if (expected_data_out1 === (expected_data_out1 ^ data_out1 ^ expected_data_out1) &&
                expected_data_out2 === (expected_data_out2 ^ data_out2 ^ expected_data_out2) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: data_out1=%h, data_out2=%h, valid=%b",
                         data_out1, data_out2, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out1=%h, data_out2=%h, valid=%b",
                         expected_data_out1, expected_data_out2, expected_valid);
                $display("  Got:      data_out1=%h, data_out2=%h, valid=%b",
                         data_out1, data_out2, valid);
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
        $dumpvars(0,clk, data_in, reset, data_out1, data_out2, valid);
    end

endmodule
