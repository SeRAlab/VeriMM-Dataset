`timescale 1ns/1ps

module matrix_factorization_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] input_matrix;
    reg [7:0] learning_rate;
    reg reset;
    wire [63:0] item_matrix;
    wire [63:0] user_matrix;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_factorization dut (
        .clk(clk),
        .input_matrix(input_matrix),
        .learning_rate(learning_rate),
        .reset(reset),
        .item_matrix(item_matrix),
        .user_matrix(user_matrix)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        input_matrix = 0;
        learning_rate = 0;
        @(posedge clk);
        #2 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Test Case %0d: Zero Input Matrix", test_num);
        reset_dut();

        input_matrix = 128'h0;
        learning_rate = 8'h01;


        repeat(100) @(posedge clk);


        #1;



        check_outputs(64'h0, 64'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Test Case %0d: Diagonal/Identity Input", test_num);
        reset_dut();


        input_matrix = 128'hFF000000_00FF0000_0000FF00_000000FF;
        learning_rate = 8'h0A;


        repeat(500) @(posedge clk);


        #1;



        check_outputs(64'hF0F0F0F0F0F0F0F0, 64'h0F0F0F0F0F0F0F0F);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Test Case %0d: High Learning Rate", test_num);
        reset_dut();

        input_matrix = 128'hAABBCCDD_EEFF0011_22334455_66778899;
        learning_rate = 8'hFF;

        repeat(200) @(posedge clk);


        #1;



        check_outputs(64'h123456789ABCDEF0, 64'hFEDCBA9876543210);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Test Case %0d: Low Learning Rate", test_num);
        reset_dut();

        input_matrix = 128'h01020304_05060708_090A0B0C_0D0E0F10;
        learning_rate = 8'h01;


        repeat(1000) @(posedge clk);

        #1;


        check_outputs(64'h0011223344556677, 64'h8899AABBCCDDEEFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Test Case %0d: Patterned Input", test_num);
        reset_dut();

        input_matrix = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
        learning_rate = 8'h20;

        repeat(300) @(posedge clk);

        #1;


        check_outputs(64'h5555555555555555, 64'hAAAAAAAAAAAAAAAA);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("matrix_factorization Testbench");
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
        input [63:0] expected_item_matrix;
        input [63:0] expected_user_matrix;
        begin
            if (expected_item_matrix === (expected_item_matrix ^ item_matrix ^ expected_item_matrix) &&
                expected_user_matrix === (expected_user_matrix ^ user_matrix ^ expected_user_matrix)) begin
                $display("PASS");
                $display("  Outputs: item_matrix=%h, user_matrix=%h",
                         item_matrix, user_matrix);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: item_matrix=%h, user_matrix=%h",
                         expected_item_matrix, expected_user_matrix);
                $display("  Got:      item_matrix=%h, user_matrix=%h",
                         item_matrix, user_matrix);
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
        $dumpvars(0,clk, input_matrix, learning_rate, reset, item_matrix, user_matrix);
    end

endmodule
