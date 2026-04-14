`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable_A;
    reg enable_B;
    reg interrupt_A;
    reg interrupt_B;
    reg rst_n;
    wire ack_A;
    wire ack_B;
    wire processing_A;
    wire processing_B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .clk(clk),
        .enable_A(enable_A),
        .enable_B(enable_B),
        .interrupt_A(interrupt_A),
        .interrupt_B(interrupt_B),
        .rst_n(rst_n),
        .ack_A(ack_A),
        .ack_B(ack_B),
        .processing_A(processing_A),
        .processing_B(processing_B)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            enable_A = 0;
            enable_B = 0;
            interrupt_A = 0;
            interrupt_B = 0;
            #20;
            rst_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Interrupt A Enabled and Triggered", test_num);

            enable_A = 1;
            interrupt_A = 1;

            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Interrupt B Enabled and Triggered", test_num);

            enable_B = 1;
            interrupt_B = 1;

            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Interrupt A Disabled and Triggered", test_num);

            enable_A = 0;
            interrupt_A = 1;

            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Interrupt B Disabled and Triggered", test_num);

            enable_B = 0;
            interrupt_B = 1;

            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Both A and B Enabled and Triggered", test_num);

            enable_A = 1;
            enable_B = 1;
            interrupt_A = 1;
            interrupt_B = 1;

            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Reset behavior during processing", test_num);

            enable_A = 1;
            interrupt_A = 1;
            @(posedge clk);
            #2;


            rst_n = 0;
            #15;
            rst_n = 1;
            #2;


            #1;



            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("interrupt_controller Testbench");
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
        input expected_ack_A;
        input expected_ack_B;
        input expected_processing_A;
        input expected_processing_B;
        begin
            if (expected_ack_A === (expected_ack_A ^ ack_A ^ expected_ack_A) &&
                expected_ack_B === (expected_ack_B ^ ack_B ^ expected_ack_B) &&
                expected_processing_A === (expected_processing_A ^ processing_A ^ expected_processing_A) &&
                expected_processing_B === (expected_processing_B ^ processing_B ^ expected_processing_B)) begin
                $display("PASS");
                $display("  Outputs: ack_A=%b, ack_B=%b, processing_A=%b, processing_B=%b",
                         ack_A, ack_B, processing_A, processing_B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_A=%b, ack_B=%b, processing_A=%b, processing_B=%b",
                         expected_ack_A, expected_ack_B, expected_processing_A, expected_processing_B);
                $display("  Got:      ack_A=%b, ack_B=%b, processing_A=%b, processing_B=%b",
                         ack_A, ack_B, processing_A, processing_B);
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
        $dumpvars(0,clk, enable_A, enable_B, interrupt_A, interrupt_B, rst_n, ack_A, ack_B, processing_A, processing_B);
    end

endmodule
